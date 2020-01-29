func multi_bleu : mosesdecoder
    < in
    < ref
    > bleu {
  ~/mosesdecoder/scripts/generic/multi-bleu.perl -lc $ref < $in > $bleu
}