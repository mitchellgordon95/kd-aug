import "tapes/submitters.tape"
import "tapes/versioners.tape"
import "tapes/sockeye.tape"
import "tapes/bleu.tape"

## Tasks start here
import "tapes/link_data.tape"
import "tapes/data_prep.tape"
import "tapes/teachers.tape"
import "tapes/distilling.tape"
import "tapes/students.tape"
import "tapes/evals.tape"

plan all {
  reach gd_teacher_bleu_dev, adapted_teacher_bleu_dev, id_baseline_teacher_bleu_dev, gd_student_bleu_dev, gd_baseline_student_bleu_dev, adapted_gd_student_bleu_dev, adapted_gd_student_baseline_bleu_dev, id_student_bleu_dev, id_baseline_student_bleu_dev, id_small_baseline_bleu_dev via (Domain: *) * (Lang: deen) * (StudentSize: *)
}


# Nuts and bolts:
global {
  ducttape_experimental_packages=true
  ducttape_experimental_submitters=true
  ducttape_experimental_imports=true
  ducttape_experimental_multiproc=true
}

