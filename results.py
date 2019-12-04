from parse import parse
from subprocess import check_output
import os

BLEU_TEMPLATE = """BLEU = {bleu}, {rest}
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

def bleu(task, lang, domain, student_size):
    parts = [
         f'Domain.{domain}' if domain else '',
         f'Lang.{lang}' if lang else '',
         f'StudentSize.{student_size}' if student_size else '',
         f'TestMode.no',
    ]

    bleu_fname = f'out/{task}_bleu_dev/{"+".join([part for part in parts if part])}/bleu'
    log_fname = f'out/train_{task}/{"+".join([part for part in parts if part])}/job.out'
    parsed = parse_file(bleu_fname, BLEU_TEMPLATE)
    if parsed:
        return parsed['bleu']
    parsed = log_file_bleu(log_fname)
    if parsed:
        return f"{float(parsed['bleu'])*100:.2f}*"
    return '0'

def row(task, domain, student_size, pretty_name):
    return f"{pretty_name:40} & " + " & ".join([bleu(task, lang, domain, student_size) for lang in ['deen', 'ruen']]) + "\\\\"

print(row('gd_teacher', None, None, 'Teacher'))
print(row('gd_student', None, 'half', 'Half Student'))
print(row('gd_baseline_student', None, 'half', 'Half Sized Baseline'))

for domain in ['ted', 'wipo']:
    print()
    print('TED & & \\\\' if domain == 'ted' else "WIPO & & \\\\")
    print(row('adapted_teacher', domain, None, 'Adapted Teacher'))
    print(row('id_baseline_teacher', domain, None, 'Baseline Teacher'))

    print(row('adapted_gd_student', domain, 'half', 'Adapted Half GD Student'))
    print(row('adapted_gd_student_baseline', domain, 'half', 'Adapted GD Half Baseline'))
    print(row('id_student', domain, 'half', 'ID Half Student'))
    print(row('id_baseline_student', domain, 'half', 'ID Half Baseline Student'))
    print(row('id_small_baseline', domain, 'half', 'ID Half Baseline'))

    print(row('adapted_gd_student', domain, 'quarter', 'Adapted Quarter GD Student'))
    print(row('adapted_gd_student_baseline', domain, 'quarter', 'Adapted GD Quarter Baseline'))
    print(row('id_student', domain, 'quarter', 'ID Quarter Student'))
    print(row('id_baseline_student', domain, 'quarter', 'ID Quarter Baseline Student'))
    print(row('id_small_baseline', domain, 'quarter', 'ID Quarter Baseline'))
