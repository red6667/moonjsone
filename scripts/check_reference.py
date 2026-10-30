"""Verify normative corpus, every generated test input, and reference evidence locks."""
import hashlib,json,pathlib,re
r=pathlib.Path(__file__).resolve().parents[1]
lock=json.loads((r/'tests/fixtures/source-lock.json').read_text(encoding='utf8'))
for name,digest in lock['files'].items():
 raw=(r/name).read_bytes().replace(b'\r\n',b'\n')
 assert hashlib.sha256(raw).hexdigest()==digest,name+' digest mismatch'
cases=json.loads((r/'tests/fixtures/specification.json').read_text(encoding='utf8'))
source=(r/'specification_test.mbt').read_text(encoding='utf8')
blocks=source.split('///|')[1:]
assert len(blocks)==len(cases)==1175
for i,(c,block) in enumerate(zip(cases,blocks)):
 assert 'upstream %04d '%i in block
 literals=re.findall(r'@json\.parse\(\s*("(?:[^"\\]|\\.)*")\s*,?\s*\)',block)
 values=[json.loads(json.loads(x)) for x in literals]
 assert values[:2]==[c['template'],c['context']],i
 error=bool(c.get('error') or c.get('panic'))
 assert ('assert_true(failed)' in block)==error,i
 if not error:assert values[2]==c.get('result'),i
print(json.dumps({'cases':len(cases),'templates_and_expected_results':'verified','reference_revision':lock['revision']}))
