func multi_bleu : mosesdecoder
    < in
    < ref
    > bleu {

  $mosesdecoder/scripts/generic/multi-bleu.perl -lc $ref < $in > $bleu
}

 # task sacrebleu : sacrebleu
 #     < in=$detokenized_output
 #     < ref=$out@dummy_aggregate_merge[DataSection:devtest,DevtestDataSection:test,side:trg]
 #     > bleu
 #     > signature
 #     :: .submitter=$submitter .action_flags=$action_flags .resource_flags=$resource_flags
 #     :: pyenv=@ {

 #   cat $in | sacrebleu $ref | cut -d' ' -f1 > $signature
 #   cat $in | sacrebleu $ref -b > $bleu
 # }
