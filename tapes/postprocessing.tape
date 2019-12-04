task debpe
    < in=$out@decode
    > out
    :: .submitter=@ .action_flags=$action_flags .resource_flags=$resource_flags {

  cat $in | sed -r 's/\@\@ //g' > $out
}