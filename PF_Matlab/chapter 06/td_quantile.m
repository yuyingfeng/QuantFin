%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Capital University of Economics and Business(CUEB)
%  School of Finance, Dept. of International Finance 
%  Professor :Marcus, Yingfeng, Yu
%  Copyright (c) 2015, Yingfeng Yu
%  All rights reserved.
%  Quantitative Finance and MacroEconomics Group(QFnME) teaching materials
%  Contact info: yuyingfeng@cueb.edu.cn

function td_quant=td_quantile(zs,d)
NN=length(zs);
    for i=1:NN
        p=(i-0.5)/NN;
        %in matlab tinv is one-side, instead of two-side,
        % not like excel %yyf's comments
        if p<=0.5
           td_quant(i)=-abs(tinv(p,d))*sqrt((d-2)/d);
        else
            td_quant(i)=abs(tinv((1-p),d))*sqrt((d-2)/d);
        end
    end

end