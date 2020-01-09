from parse import parse
from subprocess import check_output
import os

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
        return parse('{}bleu-val\': {bleu}, {}', last_dev)

def get_result(task, lang, domain, student_size, continued=False):
    parts = [
         f'Domain.{domain}' if domain else '',
         f'Lang.{lang}' if lang else '',
         f'StudentSize.{student_size}' if student_size else '',
         f'TestMode.no',
    ]

    continued = "continue_" if continued else ""

    if TRAIN:
        train_score_fname = f'out/{continued}{task}_score_train/{"+".join([part for part in parts if part])}/avgscore'
        parsed = parse_file(train_score_fname, TRAIN_SCORE_TEMPLATE)
        return parsed['score'] if parsed else 'inf'
    else:
        bleu_fname = f'out/{continued}{task}_bleu_dev/{"+".join([part for part in parts if part])}/bleu'
        log_fname = f'out/{continued}train_{task}/{"+".join([part for part in parts if part])}/job.out'
        parsed = parse_file(bleu_fname, BLEU_TEMPLATE)
        if parsed:
            return parsed['bleu']
        parsed = log_file_bleu(log_fname)
        if parsed:
            return f"{float(parsed['bleu'])*100:.2f}*"
        return '0'


def row(task, domain, student_size, pretty_name, continued=False):
    return f"{pretty_name:40} & " + " & ".join([get_result(task, lang, domain, student_size, continued=continued) for lang in ['deen', 'ruen', 'zhen']]) + "\\\\"

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

if __name__ == "__main__":
    begin_table('lccc', 'Model & de-en & ru-en & zh-en')
    print('\\hline')
    print(row('gd_teacher', None, None, 'Teacher'))
    print('\\hline')
    print(row('gd_student', None, 'half', 'Half Student'))
    print(row('gd_baseline_student', None, 'half', 'Half Baseline'))
    print('\\hline')
    print(row('gd_student', None, 'quarter', 'Quarter Student'))
    print(row('gd_baseline_student', None, 'quarter', 'Quarter Baseline'))
    print('\\hline')
    print(row('gd_student', None, 'tiny', 'Tiny Student'))
    print(row('gd_baseline_student', None, 'tiny', 'Tiny Baseline'))
    end_table("General Domain Models, teachers and students. Notes: Half sized students are not small enough that KD helps.", 'gd')

    print()
    begin_table('lllllccc', 'Domain & Size & Adapted From & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        print('\\hline')
        print(row('id_baseline_teacher', domain, None, f'{domain} & Large & None'))
        print(row('adapted_teacher', domain, None, f'{domain} & Large & Large'))
    end_table('In-Domain Teachers. Notes: WIPO de-en does not improve', 'id-teachers')

    print()
    begin_table('lllllccc', 'Domain & Size & ID Teacher & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('id_small_baseline', domain, size, f'{domain} & {size} & None'))
            print(row('id_baseline_student', domain, size, f'{domain} & {size} & Baseline'))
            print(row('id_student', domain, size, f'{domain} & {size} & Adapted'))
    end_table('In-Domain Students. Notes: Adapted teachers are better than ID teachers (if adaptation helped). Sometimes KD hurts?', 'id-students')

    print()
    begin_table('llllccc', 'Domain & Size & Adapted From & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('id_small_baseline', domain, size, f'{domain} & {size} & None'))
            print(row('adapted_gd_student_baseline', domain, size, f'{domain} & {size} & Baseline'))
            print(row('adapted_gd_student', domain, size, f'{domain} & {size} & Student'))
    end_table('Adapted In-Domain Models. Notes: KD does not affect adaptability. Better GD $\\rightarrow$ Better ID. Both are better than no adaptation (except WIPO de-en. Check domain sim?).', 'id-adapted')

    print()
    begin_table('lllllccc', 'Domain & Size & Adapted From & ID Teacher & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('adapted_gd_student', domain, size, f'{domain} & {size} & Student & None'))
            print(row('gdsbt', domain, size, f'{domain} & {size} & Student & Baseline'))
            print(row('daad', domain, size, f'{domain} & {size} & Student & Adapted'))
    end_table('Adapted Teachers and Students. Notes: Suspect that the benefits of adapting both teachers and students compound.', 'id-adapt-both')

    print()
    begin_table('lccc', 'Model & de-en & ru-en & zh-en')
    print('\\hline')
    print(row('gd_student', None, 'half', 'Half Student'))
    print(row('gd_student', None, 'half', 'Half Student Continued', continued=True))
    print('\\hline')
    print(row('gd_student', None, 'quarter', 'Quarter Student'))
    print(row('gd_student', None, 'quarter', 'Quarter Student Continued', continued=True))
    print('\\hline')
    print(row('gd_student', None, 'tiny', 'Tiny Student'))
    print(row('gd_student', None, 'tiny', 'Tiny Student Continued', continued=True))
    end_table('Continue Training GD Models on Gold Data. Seems to always help.', 'gd-continue')

    print()
    begin_table('llllllccc', 'Domain & Size & Adapted From & ID Teacher & Continued? & de-en & ru-en & zh-en')
    for domain in ['ted', 'wipo']:
        for size in ['half', 'quarter', 'tiny']:
            print('\\hline')
            print(row('id_baseline_student', domain, size, f'{domain} & {size} & None & Baseline & No'))
            print(row('id_baseline_student', domain, size, f'{domain} & {size} & None & Baseline & Yes', continued=True))
            print('\\hline')
            print(row('id_student', domain, size, f'{domain} & {size} & None & Adapted & No'))
            print(row('id_student', domain, size, f'{domain} & {size} & None & Adapted & Yes', continued=True))
    end_table('Continue Training ID Models on Gold Data. Notes: Whether this helps seems to depend on the dataset. Interested to see trends for other languages, but punting until other jobs are complete.', 'id-continue')
