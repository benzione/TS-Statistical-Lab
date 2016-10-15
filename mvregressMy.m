function [data]=mvregressMy(Z,Y)
    [n,r]=size(Z);
    [~,m]=size(Y);
    
    
%     pred_cell = cell(n,1);
%     for i = 1:n,
%         % For each of the n points, set up a design matrix specifying
%         % a different intercept but common slope terms
%         pred_cell{i,1} = [eye(m), repmat(Z(i,:),m,1)];
%     end
%     data.b = mvregress(pred_cell, Y);
    
    Z=[ones(n,1),Z];
%     calculate degree of freedom
    dofChi=m*(r-(r-1));
%     find beta
    beta=(Z'*Z)\(Z'*Y);
    Yhat=Z*beta;
    
%     find total sigma
    error=((Y-Yhat)'*(Y-Yhat));
    sigmaAll=error/n;
    E=n*sigmaAll;
    data.wilk=zeros(r+1,1);
    data.stati=zeros(r+1,1);
    
%     start to calculate Wilks' Lambada statistic
    for i=1:r+1
        ZNotTestMatrix=Z;
        ZNotTestMatrix(:,i)=[];
        betaNotTestMatrix=(ZNotTestMatrix'*ZNotTestMatrix)\(ZNotTestMatrix'*Y);
        sigmaNotTest=(Y-ZNotTestMatrix*betaNotTestMatrix)'*...
            (Y-ZNotTestMatrix*betaNotTestMatrix)/n;
        H=n*(sigmaNotTest-sigmaAll);
%         calculate the chi statistic
        data.wilk(i)=det(E)/det(E+H);
        tmp1=log(data.wilk(i));
        data.stati(i)=-(n-r-1-(m-r+(r-1)+1)/2)*tmp1;  
    end
%     calculate P value
    PValueChi=1-chi2cdf(data.stati,dofChi);
%     calculate R^2
    Yavr=mean(Y);
    msr=zeros(1,2);
    mse=zeros(1,2);
    data.r2=zeros(1,2);
    data.adjR2=zeros(1,2);
    for i=1:m
        msr(i)=((Y(:,i)-Yavr(i))'*(Y(:,i)-Yavr(i)))/n;
%         mse(i)=((Z*data.beta(:,i)-Yavr(i))'*(Z*data.beta(:,i)-Yavr(i)))/n;
        mse(i)=((Y(:,i)-Yhat(:,i))'*(Y(:,i)-Yhat(:,i)))/n;
        r2(i)=1-mse(i)/msr(i);
        adjR2(i)=1-(1-r2(i))*(n-1)/(n-r-1);
    end 
    data.beta=round(beta*1000)/1000;
    data.PValueChi=round(PValueChi*1000)/1000;
    data.r2=round(r2*1000)/1000;
    data.adjR2=round(adjR2*1000)/1000;
end