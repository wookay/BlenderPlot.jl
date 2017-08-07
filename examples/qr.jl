A = [-3 2 1; -1 4 1; 1 -3 1]
Q, R = qr(A)
# isapprox(Q*R, A)

o = [0, 0, 0]
vectordraw(o, A[:,1]; color=RGB(1,0,0)) # red
vectordraw(o, A[:,2]; color=RGB(0,1,0)) # green
vectordraw(o, A[:,3]; color=RGB(0,0,1)) # blue

vectordraw(o, Q[:,1]; color=RGB(0,1,1)) # cyan
vectordraw(o, Q[:,2]; color=RGB(1,0,1)) # magenta
vectordraw(o, Q[:,3]; color=RGB(1,1,0)) # yellow
