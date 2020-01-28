from results import get_result
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

def f_get_result(task, lang, domain, size):
    return float(get_result(task, lang, domain, size).replace('*', ''))

fig, axes = plt.subplots()

colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf']
cur_color = 0

axes.set_xlim([20, 50])
axes.set_ylim([0, 50])
legend_entries = []
for lang in ['deen', 'ruen', 'zhen']:
    for domain in ['wipo', 'ted']:
        axes.text(f_get_result('gd_teacher', lang, None, None),
                     f_get_result('adapted_teacher', lang, domain, None), 'T', c=colors[cur_color])
        for size in ['half', 'quarter', 'tiny']:
            marker = {'half': 'M', 'quarter': 'S', 'tiny': 't'}.get(size)
            axes.text(f_get_result('gd_baseline_student', lang, None, size),
                        f_get_result('adapted_gd_student_baseline', lang, domain, size), marker+'B', c=colors[cur_color])
            axes.text(f_get_result('gd_student', lang, None, size),
                        f_get_result('adapted_gd_student', lang, domain, size), marker+'S', c=colors[cur_color])
        legend_entries.append(mpatches.Patch(color=colors[cur_color], label=f'{lang} {domain}'))
        cur_color = cur_color + 1

axes.text(29, 0, """M = Medium, S = Small, t = Tiny
T = Teacher, S = Student, B = Baseline
""")

axes.set_xlabel("General-Domain Development BLEU")
axes.set_ylabel("In-Domain Development BLEU")
axes.set_title("General Domain vs. In-Domain BLEU")
axes.legend(handles=legend_entries, loc='lower left')
fig.tight_layout()
fig.savefig('gd_vs_id.png')
