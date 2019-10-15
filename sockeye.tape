import "tapes/submitters.tape"
import "tapes/versioners.tape"
import "tapes/dummy.tape"
import "tapes/pipeline.tape"

# ==== pipeline starts here ====

# download all the data to the local directory
import "tapes/download.tape"

# task binarize_data, train and decode fits in here in the execution order
# these tasks are usually the ones that needs to be defined for each toolkit
import "tapes/sockeye.tape"

import "tapes/bleu.tape"

# ==== pipeline ends here ====

plan test {
#   reach sacrebleu via
#     (TrainDataSource: iwslt_deen_2014) * 
#     (SgmDev: yes) * (DevDataSource: iwslt_deen_dev2012) * 
#     (SgmTest: yes) * (TestDataSource: iwslt_deen_test2012_small) * 
#     (TestMode: yes)
    reach sacrebleu
}

# Nuts and bolts:
global {
  ducttape_experimental_packages=true
  ducttape_experimental_submitters=true
  ducttape_experimental_imports=true
  ducttape_experimental_multiproc=true
}

