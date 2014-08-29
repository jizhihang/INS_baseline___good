function sp_feaure = sp( feature, height, width, pyramid )
dim = size(feature,1);
feature_set = feature((dim-1):dim,:);
d = feature(1:(dim-2),:);

pLevels = length(pyramid);
pBins = pyramid.^2;
tBins = sum(pBins);

sp_feaure = zeros((dim-2), tBins);
bId = 0;

for iter1 = 1:pLevels 
    
    nBins = pBins(iter1);
    wUnit = width / pyramid(iter1);
    hUnit = height / pyramid(iter1);
    
    xBin = ceil(feature_set(1, :) / wUnit);
    yBin = ceil(feature_set(2, :) / hUnit);
    idxBin = (yBin - 1)*pyramid(iter1) + xBin;
    
    for iter2 = 1:nBins    
        bId = bId + 1;
        sidxBin = find(idxBin == iter2);
        if isempty(sidxBin)
            continue;
        end      
        sp_feaure(:, bId) = max(d(:, sidxBin), [], 2); % get the max according to the line
    end
end

if bId ~= tBins
    error('Index number error!');
end

sp_feaure = sp_feaure(:);
sp_feaure = sp_feaure./sqrt(sum(sp_feaure.^2));
sp_feaure = sp_feaure';
