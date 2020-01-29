import "tapes/submitters.tape"
import "tapes/versioners.tape"
import "tapes/sockeye.tape"
import "tapes/bleu.tape"

## Tasks start here
import "tapes/data_prep.tape"
import "tapes/teacher.tape"
import "tapes/distilling.tape"
import "tapes/student.tape"

plan all {
  reach teacher_bleu_dev, student_bleu_dev via (Dataset: ted) * (Lang: deen) * (TeacherSize: large) * (StudentSize: tiny)
}


# Nuts and bolts:
global {
  ducttape_experimental_packages=true
  ducttape_experimental_submitters=true
  ducttape_experimental_imports=true
  ducttape_experimental_multiproc=true
}

