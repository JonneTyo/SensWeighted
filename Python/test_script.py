import seasWeighted
import pandas as pd
import unittest

class TestSensWeight(unittest.TestCase):

    def test_defaults(self):
        df = pd.read_csv('generated_sens_spec.csv', index_col=0)
        df_y = pd.read_csv('python_test_results.csv', index_col=0).sort_index()

        methods = sorted(['SenJ', 'SenLin', 'SenCirc', 'SenEll', 'SenConp'])
        results_df = pd.DataFrame(index=methods, columns=['sens', 'spec'])
        for method in methods:
            method_f = getattr(seasWeighted, method)
            sens, spec, _ = method_f(df['sens'], df['spec'])
            results_df.loc[method] = [sens, spec]
        try:
            self.assertEqual((results_df == df_y).astype(int).sum().sum(), df_y.shape[0]*df_y.shape[1])
        except AssertionError:
            raise AssertionError(f'Detected Assertion error on default values', results_df == df_y)

if __name__ == '__main__':
    unittest.main()