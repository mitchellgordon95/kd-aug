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
        log_fname = f'out/train_{task}/{"+".join([part for part in parts if part])}/job.out'
        parsed = parse_file(bleu_fname, BLEU_TEMPLATE)
        if parsed:
            return parsed['bleu']
        parsed = log_file_bleu(log_fname)
        if parsed:
            return f"{float(parsed['bleu'])*100:.2f}*"
        return '0'


def row(task, domain, student_size, pretty_name, continued=False):
    return f"{pretty_name:40} & " + " & ".join([get_result(task, lang, domain, student_size, continued=continued) for lang in ['deen', 'ruen']]) + "\\\\"



print(row('gd_teacher', None, None, 'Teacher'))
print(row('gd_student', None, 'half', 'Half Student'))
print(row('gd_baseline_student', None, 'half', 'Half Sized Baseline'))
print(row('gd_student', None, 'quarter', 'Quarter Student'))
print(row('gd_baseline_student', None, 'quarter', 'Quarter Sized Baseline'))

for domain in ['ted', 'wipo']:
    print('\\hline')
    print(row('id_baseline_teacher', domain, None, f'{domain} & Large & None & N/A & N/A'))
    print(row('adapted_teacher', domain, None, f'{domain} & Large & Large & N/A & N/A'))
    for size in ['half', 'quarter']:
        print('\\hline')
        print(row('id_small_baseline', domain, size, f'{domain} & {size} & None & None & No'))
        print(row('id_baseline_student', domain, size, f'{domain} & {size} & None & Baseline & No'))
        print(row('id_baseline_student', domain, size, f'{domain} & {size} & None & None & Yes', continued=True))
        print(row('id_student', domain, size, f'{domain} & {size} & None & Adapted & No'))
        print(row('id_student', domain, size, f'{domain} & {size} & None & Adapted & Yes', continued=True))
        print(row('adapted_gd_student_baseline', domain, size, f'{domain} & {size} & Baseline & None & No'))
        print(row('adapted_gd_student', domain, size, f'{domain} & {size} & Student & None & No'))
