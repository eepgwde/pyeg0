stanmodelcode = '''
data {
  int<lower=0> N;
  real y[N];
}

parameters {
  real mu;
}

model {
  mu ~ normal(0, 10);
  y ~ normal(mu, 1);
}
'''
r = stanc(model_code=stanmodelcode, model_name = "normal1")
sorted(r.keys())
pcode', 'model_code', 'model_cppname', 'model_name', 'status']
r['model_name']
mal1'
