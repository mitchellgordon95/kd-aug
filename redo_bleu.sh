for x in out/*_bleu_dev/*/ducttape_task.sh; do  cd $(dirname $x); export bleu='bleu'; pwd; chmod +x ducttape_task.sh; ./ducttape_task.sh; cd -; done
