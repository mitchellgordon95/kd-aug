from parse import parse
from subprocess import check_output
import os
import numpy as np

TRAIN = False

BLEU_TEMPLATE = """BLEU = {bleu}, {rest}
"""

TRAIN_SCORE_TEMPLATE = """{score}
"""

def parse_file(fname, template):
    try:
        with open(fname, 'r') as f:
            return parse(template, f.read())
    except FileNotFoundError:
        # print(f"Missing {fname}")
        return None

def log_file_bleu(fname):
    FNULL = open(os.devnull, 'w')
    last_dev = str(check_output(f'grep bleu-val {fname} | tail -n 1', shell=True, stderr=FNULL))
    if last_dev:
        parsed = parse('{}bleu-val\': {bleu}, {}', last_dev)
        if parsed:
            return f"{float(parsed['bleu'])*100:.2f}*"
    return '0'

def get_result(task, lang, domain, student_size, version='original'):
    parts = [
         f'Domain.{domain}' if domain else '',
         f'Lang.{lang}' if lang else '',
         f'StudentSize.{student_size}' if student_size else '',
         f'TestMode.no',
    ]

    if TRAIN:
        train_score_fname = f'out/{continued}{task}_score_train/{"+".join([part for part in parts if part])}/avgscore'
        parsed = parse_file(train_score_fname, TRAIN_SCORE_TEMPLATE)
        return parsed['score'] if parsed else 'inf'
    else:
        original_bleu_fname = f'out/{task}_bleu_dev/{"+".join([part for part in parts if part])}/bleu'
        original_log_fname = f'out/train_{task}/{"+".join([part for part in parts if part])}/job.out'
        continued_bleu_fname = f'out/continue_{task}_bleu_dev/{"+".join([part for part in parts if part])}/bleu'
        continued_log_fname = f'out/continue_train_{task}/{"+".join([part for part in parts if part])}/job.out'

        parsed = parse_file(original_bleu_fname, BLEU_TEMPLATE)
        original_bleu = float(parsed['bleu']) if parsed else 0
        parsed = parse_file(continued_bleu_fname, BLEU_TEMPLATE)
        continued_bleu = float(parsed['bleu']) if parsed else 0

        if version == 'original':
            if original_bleu:
                return f'{original_bleu:.2f}'
            else:
                return log_file_bleu(original_log_fname)
        if version == 'continued':
            if continued_bleu:
                return f'{continued_bleu:.2f}'
            else:
                return log_file_bleu(continued_log_fname)
        if version == 'best':
            return f'{max([original_bleu, continued_bleu]):.2f}'

def row(task, domain, student_size, pretty_name, version='original'):
    return f"{pretty_name:40} & " + " & ".join([get_result(task, lang, domain, student_size, version=version) for lang in ['deen', 'ruen', 'zhen']]) + "\\\\"

def begin_table(cols, headers):
    print(f"""
    \\begin{{table}}
    \\centering
    \\begin{{tabular}}{{{cols}}}
    {headers}\\\\
    """)

def end_table(caption, label):
    print(f"""
    \\end{{tabular}}
    \\caption{{{caption}}}
    \\label{{tab:{label}}}
    \\end{{table}}
    """)

def size_name(size):
    return {'half': 'medium', 'quarter': 'small', 'tiny': 'tiny'}.get(size)

if __name__ == "__main__":
    begin_table('lccc', 'Model & de-en & ru-en & zh-en')
    print('\\hline')
    print(row('gd_teacher', None, None, 'Teacher'))
    print('\\hline')
    print(row('gd_student', None, 'half', 'Medium Student'))
    print(row('gd_baseline_student', None, 'half', 'Medium Baseline'))
    print('\\hline')
    print(row('gd_student', None, 'quarter', 'Small Student'))
    print(row('gd_baseline_student', None, 'quarter', 'Small Baseline'))
    print('\\hline')
    print(row('gd_student', None, 'tiny', 'Tiny Student'))
    print(row('gd_baseline_student', None, 'tiny', 'Tiny Baseline'))
    end_table("General Domain Models, teachers and students. Notes: Half sized students are not small enough that KD helps.", 'gd')

    print()
    begin_table('lllccc', 'Domain & Size & Adapted From & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        print('\\hline')
        print(row('id_baseline_teacher', domain, None, f'{domain} & Large & None'))
        print(row('adapted_teacher', domain, None, f' & & Large'))
    end_table('In-Domain Teachers. Notes: WIPO de-en does not improve', 'id-teachers')

    print()
    begin_table('llcccc', 'Domain & Size & Config \\# & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('id_small_baseline', domain, size, f' &  & 1', version='best'))
            print(row('id_baseline_student', domain, size, f'{domain if size == "half" else ""} & {size_name(size)} & 2', version='best'))
            print(row('id_student', domain, size, f' &  & 3', version='best'))
    end_table('In-Domain Students. Notes: Adapted teachers are better than ID teachers (if adaptation helped). Sometimes KD hurts?', 'id-students')

    print()
    begin_table('llcccc', 'Domain & Size & Config \\# & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('id_small_baseline', domain, size, f' &  & 1'))
            print(row('adapted_gd_student_baseline', domain, size, f'{domain if size == "half" else ""} & {size_name(size)} & 4'))
            print(row('adapted_gd_student', domain, size, f' &  & 7'))
    end_table('Adapted In-Domain Models. Notes: KD does not affect adaptability. Better GD $\\rightarrow$ Better ID. Both are better than no adaptation (except WIPO de-en. Check domain sim?).', 'id-adapted')

    print()
    begin_table('llcccc', 'Domain & Size & Config \\# & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('adapted_gd_student', domain, size, f' &  & 7', version='best'))
            print(row('gdsbt', domain, size, f'{domain if size == "half" else ""} & {size_name(size)} & 8', version='best'))
            print(row('daad', domain, size, f' &  & 9', version='best'))
    end_table('Adapted Teachers and Students. Notes: Suspect that the benefits of adapting both teachers and students compound.', 'id-adapt-both')

    print()
    begin_table('lccc', 'Model & de-en & ru-en & zh-en')
    print('\\hline')
    print(row('gd_student', None, 'half', 'Medium Student'))
    print(row('gd_student', None, 'half', 'Medium Student Continued', version="continued"))
    print('\\hline')
    print(row('gd_student', None, 'quarter', 'Small Student'))
    print(row('gd_student', None, 'quarter', 'Small Student Continued', version="continued"))
    print('\\hline')
    print(row('gd_student', None, 'tiny', 'Tiny Student'))
    print(row('gd_student', None, 'tiny', 'Tiny Student Continued', version="continued"))
    end_table('Continue Training GD Models on Gold Data. Seems to always help.', 'gd-continue')

    print()
    begin_table('llclccc', 'Domain & Size & Config \\# & Continued? & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('id_baseline_student', domain, size, f'{domain} & {size_name(size)} & 2 & No'))
            print(row('id_baseline_student', domain, size, f' &  &  & Yes', version="continued"))
            print('\\hline')
            print(row('id_student', domain, size, f' & {size_name(size)} & 3 & No'))
            print(row('id_student', domain, size, f' &  &  & Yes', version="continued"))
            print('\\hline')
            print(row('gdbat', domain, size, f' & {size_name(size)} & 6 & No'))
            print(row('gdbat', domain, size, f' &  &  & Yes', version="continued"))
            print('\\hline')
            print(row('gdsbt', domain, size, f' & {size_name(size)} & 8 & No'))
            print(row('gdsbt', domain, size, f' &  &  & Yes', version="continued"))
            print('\\hline')
            print(row('daad', domain, size, f' & {size_name(size)} & 9 & No'))
            print(row('daad', domain, size, f' &  &  & Yes', version="continued"))
        if domain == 'ted':
            end_table('This table is continued in the next.', 'id-continue-part1')
            begin_table('llclccc', 'Domain & Size & Config \\# & Continued? & de-en & ru-en & zh-en')
    end_table('Continue Training ID Models on Gold Data. Notes: Whether this helps seems to depend on the dataset. Interested to see trends for other languages, but punting until other jobs are complete.', 'id-continue-part2')

    begin_table('llcccc', 'Domain & Size & Config \\# & de-en & ru-en & zh-en')
    version = 'best'
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('id_small_baseline', domain, size, f' &  & 1', version=version))
            print(row('id_baseline_student', domain, size, f' &  & 2', version=version))
            print(row('id_student', domain, size, f' &  & 3', version=version))
            print(row('adapted_gd_student_baseline', domain, size, f'{domain if size == "half" else ""} & {size_name(size)} & 4', version=version))
            print(row('gdbat', domain, size, f' &  & 6', version=version))
            print(row('adapted_gd_student', domain, size, f' &  & 7', version=version))
            print(row('gdsbt', domain, size, f' &  & 8', version=version))
            print(row('daad', domain, size, f' &  & 9', version=version))
    end_table('everybody', 'everybody')

    begin_table('llcccc', 'Domain & Size & Config \\# & de-en & ru-en & zh-en')
    version = 'best'
    for domain in ['ted', 'wipo']:
        print('\\hline')
        for size in ['half', 'quarter', 'tiny']:
            print(row('gdbat', domain, size, f'{domain if size == "quarter" else ""} & {size_name(size)} & 6', version=version))
    end_table('Results for configuration \\# 6.', 'config-6')


    begin_table('llccc', 'Domain & Size & de-en & ru-en & zh-en')
    thresh = 0.1
    print('\\hline')
    for domain in ['ted', 'wipo']:
        if domain == 'wipo':
            print('\\hline')
        for size in ['half', 'quarter', 'tiny']:
            print(f'{domain if size == "quarter" else ""} & {size_name(size)}', end="")
            for lang in ['deen', 'ruen', 'zhen']:
                scores = np.array([
                    float(get_result('id_small_baseline', lang, domain, size, version='best')),
                    float(get_result('id_baseline_student', lang, domain, size, version='best')),
                    float(get_result('id_student', lang, domain, size, version='best')),
                    float(get_result('adapted_gd_student_baseline', lang, domain, size, version='best')),
                    float(get_result('gdbat', lang, domain, size, version='best')),
                    float(get_result('adapted_gd_student', lang, domain, size, version='best')),
                    float(get_result('gdsbt', lang, domain, size, version='best')),
                    float(get_result('daad', lang, domain, size, version='best')),
                ])
                best = np.max(scores)
                thresh_best = np.nonzero(scores > best - thresh)[0]
                for ind in range(len(thresh_best)):
                    # 0 index to 1 index
                    thresh_best[ind] += 1
                    # We skipped number 5, so 5 is actually 6, 6 is actually 7, etc.
                    if int(thresh_best[ind]) > 4:
                        thresh_best[ind] += 1

                thresh_best = thresh_best.astype(np.str).tolist()
                print(f' & {"/".join(thresh_best)}', end="")
            print("\\\\")

end_table(f'Best configurations for each setting. Scores within {thresh} BLEU of the best are also listed.', 'best-configs')



