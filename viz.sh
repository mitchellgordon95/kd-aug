# mkdir viz

# ducttape main.tape -C main.tconf -p all viz  > graph-viz.txt
# sed -i '2 i\ranksep=2' graph-viz.txt

# sed '/bleu_dev\|decode_dev/d' graph-viz.txt > viz/no_eval.txt
# dot -Tpdf viz/no_eval.txt -O

# echo "digraph G {" > viz/eval.txt
# echo "ranksep=2" >> viz/eval.txt
# sed '/bleu_dev\|decode_dev/!d' graph-viz.txt >> viz/eval.txt
# echo "}" >> viz/eval.txt
# dot -Tpdf viz/eval.txt -O

ducttape main.tape -C main.tconf -p continue_debug viz  > viz/continue.txt
sed -i '2 i\ranksep=2' viz/continue.txt
dot -Tpdf viz/continue.txt -O
