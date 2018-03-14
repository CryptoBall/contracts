def assert_approx_eq(lhs, rhs, threshold=0.01):
    assert abs(lhs - rhs) <= threshold * abs(min(lhs, rhs))
