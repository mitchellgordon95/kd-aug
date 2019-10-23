# Test the GD teacher
task gd_teacher_decode_dev calls decode 
    < in=$DEV_SRC@general_domain
    < model=$model@train_gd_teacher
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task gd_teacher_bleu_dev calls multi_bleu
     < in=$out@gd_teacher_decode_dev
     < ref=$DEV_TRG@general_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the Adapted Teacher
task adapted_teacher_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@train_adapted_teacher
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task adapted_teacher_bleu_dev calls multi_bleu
     < in=$out@adapted_teacher_decode_dev
     < ref=$DEV_TRG@in_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the ID Teacher
task id_baseline_teacher_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@train_id_baseline_teacher
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task id_baseline_teacher_bleu_dev calls multi_bleu
     < in=$out@id_baseline_teacher_decode_dev
     < ref=$DEV_TRG@in_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the GD student
task gd_student_decode_dev calls decode 
    < in=$DEV_SRC@general_domain
    < model=$model@train_gd_student
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task gd_student_bleu_dev calls multi_bleu
     < in=$out@gd_student_decode_dev
     < ref=$DEV_TRG@general_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the GD student baseline
task gd_baseline_student_decode_dev calls decode 
    < in=$DEV_SRC@general_domain
    < model=$model@train_gd_student_baseline
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task gd_baseline_student_bleu_dev calls multi_bleu
     < in=$out@gd_baseline_student_decode_dev
     < ref=$DEV_TRG@general_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the Adapted GD Student
task adapted_gd_student_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@train_adapted_gd_student
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task adapted_gd_student_bleu_dev calls multi_bleu
     < in=$out@adapted_gd_student_decode_dev
     < ref=$DEV_TRG@in_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the Adapted GD Student Baseline
task adapted_gd_student_baseline_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@train_adapted_gd_student_baseline
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task adapted_gd_student_baseline_bleu_dev calls multi_bleu
     < in=$out@adapted_gd_student_baseline_decode_dev
     < ref=$DEV_TRG@in_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the ID student
task id_student_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@train_id_student
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task id_student_bleu_dev calls multi_bleu
     < in=$out@id_student_decode_dev
     < ref=$DEV_TRG@in_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the ID student baseline
task id_baseline_student_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@train_id_baseline_student
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task id_baseline_student_bleu_dev calls multi_bleu
     < in=$out@id_baseline_student_decode_dev
     < ref=$DEV_TRG@in_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags

# Test the ID small baseline
task id_small_baseline_decode_dev calls decode 
    < in=$DEV_SRC@in_domain
    < model=$model@train_id_small_baseline
    > out out_log out_scores
    :: test_beam_size=@
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task id_small_baseline_bleu_dev calls multi_bleu
     < in=$out@id_small_baseline_decode_dev
     < ref=$DEV_TRG@in_domain
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags
