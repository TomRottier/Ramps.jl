using Test, Ramps, ForwardDiff

@testset "all" verbose = true begin
    @testset "polynomial" verbose = true begin
        @test Ramps.f(0) == 0
        @test Ramps.f(1) == 1
        @test Ramps.fp(0) == 0
        @test Ramps.fp(1) == 0
        @test Ramps.fpp(0) == 0
        @test Ramps.fpp(1) == 0
        @test Ramps.f(0.5) == 0.5
        @test Ramps.fp(0.5) == 1.875
        @test Ramps.fpp(0.5) == 0.0

        # compare derivatives to Automatic Differentiation
        test_fp(t) = ForwardDiff.derivative(Ramps.f, t)
        @test Ramps.fp(0.2) ≈ ForwardDiff.derivative(Ramps.f, 0.2)
        @test Ramps.fp(0.1234) ≈ ForwardDiff.derivative(Ramps.f, 0.1234)
        @test Ramps.fpp(0.2) ≈ ForwardDiff.derivative(test_fp, 0.2)
        @test Ramps.fpp(0.1234) ≈ ForwardDiff.derivative(test_fp, 0.1234)


    end

    @testset "single ramp" verbose = true begin
        r = Ramp(0.0, 2.0, 0.0, 1.5)
        @test evaluate(r, -0.5) == 0.0
        @test evaluate(r, 1.5) == 2.0
        @test evaluate(r, -0.5, 1) == 0.0
        @test evaluate(r, 1.5, 1) == 0.0
        @test evaluate(r, 0.0, 2) == 0.0
        @test evaluate(r, 1.5, 2) == 0.0
        @test evaluate(r, 100, 1) == 0
        @test evaluate(r, 100, 2) == 0
        @test evaluate(r, -100, 1) == 0
        @test evaluate(r, -100, 2) == 0



    end

    @testset "multi ramps" verbose = true begin
        r1 = Ramp(0.1, 0.8, 0.2, 0.5)
        r2 = Ramp(0.8, 0.6, 0.8, 1.2)
        r = MultiRamp([r1, r2])

        @test evaluate(r, 0.0) == 0.1
        @test evaluate(r, 0.5) == 0.8
        @test evaluate(r, 0.6) == 0.8
        @test evaluate(r, 1.2) == 0.6
        @test evaluate(r, 0.0, 1) == 0.0
        @test evaluate(r, 0.6, 1) == 0.0
        @test evaluate(r, 0.6, 2) == 0.0

    end

end