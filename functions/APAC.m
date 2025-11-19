function [ Paths ] = APAC( Adj_matrix, sv, ev )
% The APAC(All paths and cycle) Algorithm,implemented by Muhammad Abid Dar
% and Ms. Toseef Mehdi
% 
% This function has been designed to implement APAC algorithm proposed by 
% Ricardo Simões in his research contribution in Revista de Estudos 
% Politécnicos, Polytechnical Studies Review, 2009, Vol VII, nº12, 039-055.
% This code has been modified from the algorithm so as to get all paths
% between any two nodes of a random connected undirected graph, without 
% finding cycles. This has been the requirement of Mr. Dar's research work 
% that cycles were not needed. So the APAC algorithm was modified to 
% calculate the paths only.
% 
%
% PARAMETERS:
%   sv : the index of start node, indexing from 1
%   ev : the index of end node, indexing from 1
% Adj_matrix : the adjacent matrix or the transition matrix

% Example:"The following commands would find all the paths between nodes 1
%//////////////////////////////////////////////////////////////////////////
% and 5 using APAC algorithm for the graph represented by the adjacency 
% matrix A and return a cell array containing all these paths."

% >>A=[0 0 1 0 1 1;0 0 1 1 0 1;1 1 0 1 1 0;0 1 1 0 0 0;1 0 1 0 0 0;1 1 0 0 
% 0 0];
% >>c=APAC(A,1,5)
%//////////////////////////////////////////////////////////////////////////
if ( size(Adj_matrix,1) ~= size(Adj_matrix,2) )
  error('Adjacenecy matrix has different width and height' );
end
% 
% Initialization:
%  Adj_list     : Cell array containing the adjacency list
%  S            : Cell array working as a stack in APAC (Can be viewed in 
%                 the above told research paper)
%  P            : A set used in APAC
%  Paths        : A cell array to store all paths between the required
%                 vertices. This is been the output of our current function

Adj_list=cell(1,length(Adj_matrix));

for i=1:size(Adj_matrix,1)
Adj_list{i}=find(Adj_matrix (i,:));                     
end

S={};
P=[sv];
S={P};
Paths={};%1
while (isempty(S)==0)
    P=S{end}; 
    S=S(1:end-1);
    u=P(end);
    d=length(P);
    Adj_u=setdiff(Adj_list{u},sv);
    
for i=1:length(Adj_u)
if ismember(Adj_u(i), P)==0
    
    if (Adj_u(i)==ev)
       
        Out_Path=[P ev];                     
        
        Paths=[Paths Out_Path];
        
    else V=[];
        
         V=[P Adj_u(i)];
         
         S=[S V];
    end
end
end
end

end

