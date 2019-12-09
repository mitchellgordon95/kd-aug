func huda : sockeye
    < dataset
    < model
    > translations
    > bleu
    :: test_beam_size :: use_cpu :: pyenv {
  src="/exp/hkhayrallah/kd-generalize/data/de-en/$dataset.test.bpe.de"
  trg="/exp/hkhayrallah/kd-generalize/data/de-en/$dataset.test.bpe.en"

  if [[ $use_cpu == "yes" ]]; then
    device="--use-cpu"
  else
    visible=(${CUDA_VISIBLE_DEVICES//,/ })
    # If expr returns 0, bash quits when we're using set -e
    maxid=$(expr "${#visible[@]}" - 1) || true
    visible_mapping=$(seq -s ' ' 0 $maxid)
    device="--device-ids $visible_mapping"
  fi

  python3 -m sockeye.translate \
    -m $model \
    $device \
    -i $src \
    -o $translations \
    --beam-size 12 \
    --batch-size 10 \
    --max-input-len 300 \
    --disable-device-locking \

  ~/mosesdecoder/scripts/generic/multi-bleu.perl -lc $trg < $translations > $bleu
}

task gd_student_huda calls huda
    < model=$model@train_gd_student
    > translations > bleu
    :: dataset=(HudaData:
       acquis=acquis,
       emea=emea,
       it=it,
       koran=koran,
       ted=ted,
       wipo=wipo
    )
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task gd_student_baseline_huda calls huda
    < model=$model@train_gd_student_baseline
    > translations > bleu
    :: dataset=(HudaData:
       acquis=acquis,
       emea=emea,
       it=it,
       koran=koran,
       ted=ted,
       wipo=wipo
    )
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task id_small_baseline_huda calls huda
    < model=$model@train_id_small_baseline
    > translations > bleu
    :: dataset=(HudaData:
       acquis=acquis,
       emea=emea,
       it=it,
       koran=koran,
       ted=ted,
       wipo=wipo
    )
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode

task id_baseline_student_huda calls huda
    < model=$model@train_id_baseline_student
    > translations > bleu
    :: dataset=(HudaData:
       acquis=acquis,
       emea=emea,
       it=it,
       koran=koran,
       ted=ted,
       wipo=wipo
    )
    :: use_cpu=@ pyenv=@
    :: .submitter=@ :: .action_flags=@ :: .resource_flags=$resource_flags_decode