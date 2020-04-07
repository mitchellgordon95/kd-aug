task chunk_data
    < in=$TRAIN_SRC@bpe_data
    > out
    :: chunk=(Chunk:0..7) {
  linecount=$(wc -l $in | awk '{print $1}')
  chunksize=$(( $linecount / 8 + 1 ))
  begin=$(( $chunk * $chunksize + 1 ))
  end=$(( ($chunk + 1) * $chunksize )) 
  echo "Using lines $begin to $end inclusive"
  sed -n "${begin},${end}p;${end}q" $in > $out
}
    
task distill_data_chunk calls decode
    < in=$out@chunk_data
    < model=$model@train_teacher
    > out > out_log > out_scores
    :: use_cpu=@ pyenv=@ .submitter=@ .action_flags=@ .resource_flags=$resource_flags_decode 

# I'm not sure I can't use branch globbing here, but I want to make sure the chunks come in the right order
task distill_data
    < chunk0=$out@distill_data_chunk[Chunk:0]
    < chunk1=$out@distill_data_chunk[Chunk:1]
    < chunk2=$out@distill_data_chunk[Chunk:2]
    < chunk3=$out@distill_data_chunk[Chunk:3]
    < chunk4=$out@distill_data_chunk[Chunk:4]
    < chunk5=$out@distill_data_chunk[Chunk:5]
    < chunk6=$out@distill_data_chunk[Chunk:6]
    < chunk7=$out@distill_data_chunk[Chunk:7]
    > out {
    cat $chunk0 $chunk1 $chunk2 $chunk3 $chunk4 $chunk5 $chunk6 $chunk7 > $out 
}

task maybe_concat
    < train_src=$TRAIN_SRC@bpe_data 
    < train_trg=$TRAIN_TRG@bpe_data 
    < distilled_trg=$out@distill_data 
    > out_src
    > out_trg
    :: concat=(Concat: no yes) {

  if [ $concat == no ]; then
    ln -s $train_src $out_src
    ln -s $train_trg $out_trg
  else
    cat $train_src $train_src > $out_src
    cat $train_trg $distilled_trg > $out_trg
  fi
}