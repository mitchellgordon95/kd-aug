mkdir viz

for task in gd_teacher  adapted_teacher  id_baseline_teacher  gd_student  gd_baseline_student  adapted_gd_student  adapted_gd_student_baseline  id_student  id_baseline_student  id_small_baseline
do
    ducttape main.tape -C main.tconf -p $task viz  > graph-viz.txt && dot -Tpdf graph-viz.txt -o viz/$task.pdf
done
