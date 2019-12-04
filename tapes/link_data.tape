# These tasks are solely to make the syntax of specifying data locations
# nicer. They work by returning an output file which is just a link to the
# actual data.

task general_domain
  > TRAIN_SRC
  > TRAIN_TRG
  > DEV_SRC
  > DEV_TRG
  > SRC_VOCAB
  > TRG_VOCAB
  # TODO: see ISSUES.md #1
  :: SRC=@ TRG=@ pyenv=@ .submitter=@ .resource_flags=$resource_flags_train .action_flags=@ {
  ln -s "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$SRC" $TRAIN_SRC
  ln -s "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$TRG" $TRAIN_TRG

  ln -s "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.dev.bpe.$SRC" $DEV_SRC
  ln -s "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.dev.bpe.$TRG" $DEV_TRG

  python -m sockeye.vocab -i $TRAIN_SRC -o $SRC_VOCAB
  python -m sockeye.vocab -i $TRAIN_TRG -o $TRG_VOCAB
}

task in_domain
  > TRAIN_SRC
  > TRAIN_TRG
  > DEV_SRC
  > DEV_TRG
  :: SRC=@ TRG=@ domain=@ {
  ln -s "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC" $TRAIN_SRC
  ln -s "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$TRG" $TRAIN_TRG

  ln -s "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.dev.bpe.$SRC" $DEV_SRC
  ln -s "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.dev.bpe.$TRG" $DEV_TRG
}