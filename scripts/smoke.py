"""Run real examples and CLI failure isolation on the selected Moon backend."""
import argparse,json,subprocess,os
p=argparse.ArgumentParser();p.add_argument('--target',default='wasm-gc');a=p.parse_args()
def run(package,request=None):
 cmd=[os.environ.get('MOON_EXECUTABLE','moon'),'run',package,'--target',a.target]
 if request is not None:cmd+=['--',json.dumps(request,separators=(',',':'))]
 result=subprocess.run(cmd,check=True,capture_output=True,encoding='utf8')
 return json.loads(result.stdout)
deploy=run('examples/deployment')
assert [x['metadata']['name'] for x in deploy]==['catalog-east','catalog-west']
assert all(x['spec']['replicas']==3 for x in deploy)
matrix=run('examples/matrix')
assert [(x['os'],x['runtime']) for x in matrix]==[('linux',20),('linux',22),('windows',20),('windows',22)]
payloads=run('examples/payloads')
assert [x['id'] for x in payloads]==['case-0','case-1','case-2']
assert [x['amount'] for x in payloads]==[10,20,30]
assert [x['enabled'] for x in payloads]==[True,True,False]
batch=run('cmd/main',[{'expression':'2+3'},{'expression':'missing'},{'template':{'x':2}}])
assert batch[0]=={'ok':True,'result':5}
assert batch[1]['ok'] is False and batch[1]['category']=='invalid'
assert batch[2]=={'ok':True,'result':{'x':2}}
print(json.dumps({'target':a.target,'workflows':3,'cli_requests':3,'status':'passed'}))
