/*Вычислить прогресс пользователей по курсу. Прогресс вычисляется как отношение верно пройденных шагов к общему количеству шагов в процентах, округленное до целого. В нашей базе данные о решениях занесены не для всех шагов, поэтому общее количество шагов определить как количество различных шагов в таблице step_student.

Тем пользователям, которые прошли все шаги (прогресс = 100%) выдать "Сертификат с отличием". Тем, у кого прогресс больше или равен 80% -  "Сертификат". Для остальных записей в столбце Результат задать пустую строку ("").

Информацию отсортировать по убыванию прогресса, затем по имени пользователя в алфавитном порядке.*/

SET @max_progress = (SELECT COUNT(DISTINCT step_id) FROM step_student);
WITH tb_progress (student_name_p, progress) AS (
  SELECT 
    student_name, 
    COUNT(DISTINCT step_id) 
  FROM 
    student 
    JOIN step_student USING(student_id) 
  WHERE result = "correct"
  GROUP BY student_name 
)

SELECT
    student_name_p AS Студент,
    ROUND(progress*100/@max_progress) AS Прогресс,
    CASE
    WHEN ROUND(progress*100/@max_progress) = 100 THEN 'Сертификат с отличием'
    WHEN ROUND(progress*100/@max_progress) >= 80   THEN 'Сертификат'
    ELSE ''
    END AS Результат
FROM tb_progress
ORDER BY Прогресс DESC, Студент
