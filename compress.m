function wc=compress(w,r)
% Input is the array w and r, which is a number
% between 0 and 1.
% Output is the array wc where smallest 100r% of the 
% terms in w are set to zero (e.g r=.75 means the smallest 75% of 
% the terms are set to zero
if (r<0) | (r>1)
  error('r should be between 0 and 1')
end;
N=length(w); Nr=floor(N*r);
ww=sort(abs(w));
tol=abs(ww(Nr));
for j=1:N
   if (abs(w(j)) < tol)
	w(j)=0;
   end;
end;
wc=w;