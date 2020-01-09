from results import get_result
import matplotlib.pyplot as plt

def f_get_result(task, lang, domain, size):
    return float(get_result(task, lang, domain, size).replace('*', ''))

def get_coords(lang, domain):
    x = []
    y = []
    for size in ['half', 'quarter', 'tiny']:
        x.append(f_get_result('gd_teacher', lang, None, None))
        y.append(f_get_result('adapted_teacher', lang, domain, None))
        x.append(f_get_result('gd_baseline_student', lang, None, size))
        y.append(f_get_result('adapted_gd_student_baseline', lang, domain, size))
        x.append(f_get_result('gd_student', lang, None, size))
        y.append(f_get_result('adapted_gd_student', lang, domain, size))
    return x, y

fig, axes = plt.subplots()

for lang in ['deen', 'ruen', 'zhen']:
    for domain in ['wipo', 'ted']:
        x, y = get_coords(lang, domain)
        print(f'{lang} {domain}')
        print(f'{x}   {y}')
        axes.scatter(x, y, label=f'{lang} {domain}')
axes.legend()

fig.savefig('gd_vs_id.png')
