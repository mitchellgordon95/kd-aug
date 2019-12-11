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
import "tapes/score_train.tape"
import "tapes/huda.tape"
import "tapes/continue.tape"

plan all {
  reach gd_teacher_bleu_dev, adapted_teacher_bleu_dev, id_baseline_teacher_bleu_dev, gd_student_bleu_dev, gd_baseline_student_bleu_dev, adapted_gd_student_bleu_dev, adapted_gd_student_baseline_bleu_dev, id_student_bleu_dev, id_baseline_student_bleu_dev, id_small_baseline_bleu_dev via (Domain: *) * (Lang: deen) * (StudentSize: *)
}

plan score_train {
  reach  gd_student_score_train, gd_baseline_student_score_train, adapted_gd_student_score_train, adapted_gd_student_baseline_score_train, id_student_score_train, id_baseline_student_score_train, id_small_baseline_score_train via (Domain: *) * (Lang: deen) * (StudentSize: *)
}

plan huda {
  reach gd_student_huda, gd_student_baseline_huda, id_small_baseline_huda, id_student_baseline_huda via (Domain: *) * (Lang: deen) * (StudentSize: *) * (HudaData: *)
}

plan continue {
  reach continue_gd_student_score_train, continue_id_student_score_train, continue_id_baseline_student_score_train, continue_gd_student_bleu_dev, continue_id_student_bleu_dev, continue_id_baseline_student_bleu_dev via (Domain: *) * (Lang: deen) * (StudentSize: *)
}

plan daad {
  reach daad_bleu_dev via (Domain: *) * (Lang: deen) * (StudentSize: *)
}

# Nuts and bolts:
global {
  ducttape_experimental_packages=true
  ducttape_experimental_submitters=true
  ducttape_experimental_imports=true
  ducttape_experimental_multiproc=true
}

