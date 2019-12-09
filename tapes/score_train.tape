# Test the GD student
task gd_student_score_train calls score
     < src=$TRAIN_SRC@general_domain
     < trg=$TRAIN_TRG@general_domain
     < model=$model@train_gd_student
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

# Test the GD student baseline
task gd_baseline_student_score_train calls score
     < src=$TRAIN_SRC@general_domain
     < trg=$TRAIN_TRG@general_domain
     < model=$model@train_gd_student_baseline
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

# Test the Adapted GD Student
task adapted_gd_student_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@train_adapted_gd_student
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

# Test the Adapted GD Student Baseline
task adapted_gd_student_baseline_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@train_adapted_gd_student_baseline
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

# Test the ID student
task id_student_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@train_id_student
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

# Test the ID student baseline
task id_baseline_student_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@train_id_baseline_student
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

# Test the ID small baseline
task id_small_baseline_score_train calls score
     < src=$TRAIN_SRC@in_domain
     < trg=$TRAIN_TRG@in_domain
     < model=$model@train_id_small_baseline
     > scores
     > avgscore
     :: use_cpu=@ :: pyenv=@
     :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode