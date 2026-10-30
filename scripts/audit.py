"""Conservative substantive production LOC and useful history inventory."""
import json,pathlib,re,subprocess
r=pathlib.Path(__file__).resolve().parents[1]
files={}
for p in sorted(r.glob('*.mbt')):
 if p.name.endswith(('_test.mbt','_wbtest.mbt')):continue
 lines=[]
 for line in p.read_text(encoding='utf-8-sig').splitlines():
  line=line.strip()
  if not line or line.startswith('//'):continue
  lines.append(line)
 files[p.name]=len(lines)
commits=subprocess.check_output(['git','log','--format=%H%x09%s'],cwd=str(r),encoding='utf8').splitlines()
assert sum(files.values())>=1500,files
assert len(commits)>=20,len(commits)
assert not subprocess.check_output(['git','ls-files','--','*APPLICATION*','*.zip'],cwd=str(r),encoding='utf8').strip()
print(json.dumps({'substantive_production_lines':sum(files.values()),'files':files,'commits':len(commits),'commits_require_manual_substantive_review':True},indent=2))
