function rgb = husls2rgb(husls)

b = zeros(size(husls,1),1,3);
b(:,1,:) = husls;
rgb = squeeze(husl2rgb(b));