task bpe_data : subword_nmt
  > TRAIN_SRC
  > TRAIN_TRG
  > DEV_SRC
  > DEV_TRG
  > SRC_VOCAB
  > TRG_VOCAB
  # TODO: see ISSUES.md #1
  :: SRC=@ TRG=@ dataset=@ pyenv=@ .submitter=@ .resource_flags=$resource_flags_train .action_flags=@ {
  tok_train_src="/exp/scale18/mt/data/$SRC-$TRG/$dataset/$dataset.train.tok.$SRC" 
  tok_train_trg="/exp/scale18/mt/data/$SRC-$TRG/$dataset/$dataset.train.tok.$TRG" 

  tok_dev_src="/exp/scale18/mt/data/$SRC-$TRG/$dataset/$dataset.dev.tok.$SRC"
  tok_dev_trg="/exp/scale18/mt/data/$SRC-$TRG/$dataset/$dataset.dev.tok.$TRG"

  # Learn the BPE vocab from the training data
  subword-nmt learn-bpe -s 30000 < $tok_train_src > $SRC_VOCAB
  subword-nmt learn-bpe -s 30000 < $tok_train_trg > $TRG_VOCAB

  # Apply it to both train and dev
  subword-nmt apply-bpe -c $SRC_VOCAB < $tok_train_src > $TRAIN_SRC
  subword-nmt apply-bpe -c $TRG_VOCAB < $tok_train_trg > $TRAIN_TRG

  subword-nmt apply-bpe -c $SRC_VOCAB < $tok_dev_src > $DEV_SRC
  subword-nmt apply-bpe -c $TRG_VOCAB < $tok_dev_trg > $DEV_TRG
}