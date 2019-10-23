# These tasks are solely to make the syntax of specifying data locations
# nicer. They work by returning an output file which is just a link to the
# actual data.

task general_domain
  > TRAIN_SRC
  > TRAIN_TRG
  > DEV_SRC
  > DEV_TRG
  :: SRC=@ TRG=@ {
  ln "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$SRC" $TRAIN_SRC
  ln "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.train.bpe.$TRG" $TRAIN_TRG

  ln "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.dev.bpe.$SRC" $DEV_SRC
  ln "/exp/scale18/mt/data/$SRC-$TRG/generaldomain/generaldomain.dev.bpe.$TRG" $DEV_TRG
}

task in_domain
  > TRAIN_SRC
  > TRAIN_TRG
  > DEV_SRC
  > DEV_TRG
  :: SRC=@ TRG=@ domain=@ {
  ln "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$SRC" $TRAIN_SRC
  ln "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.train.bpe.$TRG" $TRAIN_TRG

  ln "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.dev.bpe.$SRC" $DEV_SRC
  ln "/exp/scale18/mt/data/$SRC-$TRG/$domain/$domain.dev.bpe.$TRG" $DEV_TRG
}