%***************************************************************************
%                                  Set-up.
% *********************************************************************************
% This software package is It is an universal post-processing framework for 
% fluorescent (or intensity-based) image restoration, including 
% xy (2D), xy-t (2D along t axis), and xy-z (3D) images. 
% It is based on the natural priori knowledge of forward fluorescent 
% imaging model: sparsity and continuity along xy-t(z) axes.
% *********************************************************************************
% Sparse-SIM algorithm GUI v1.0.3
% *********************************************************************************
%% It is able to run under Windows 7-10, and should be modified for the Unix systems.
% ------------------------------------------------------------------------------------------------
% argmin_g { ||f-g ||_2^2 +||gxx||_1+||gxx||_1+||gyy||_1+lamdbaz*||gzz||_1+2*||gxy||_1
%  +2*sqrt(lamdbaz)||gxz||_1+ 2*sqrt(lamdbaz)|||gyz||_1+2*sqrt(lamdbal1)|||g||_1}
% *********************************************************************************
% Written by WeisongZhao @ zhaoweisong950713@163.com
% if any bugs is found, please just email me or put an issue on the github.
% *********************************************************************************
% https://weisongzhao.github.io/Sparse-SIM/
% *********************************************************************************
% It is a part of publication:
% Weisong Zhao et al. Extending resolution of structured illumination
% microscopy with sparse deconvolution, Nature Biotechnology, X, XXX-XXX (2021).
% *********************************************************************************
%   Copyright 2019~2021 Weisong Zhao et al.
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%***************************************************************************
clc;clear;close all;warning off;
addpath('./Utils/');
addpath('./SHOperation/');
addpath('./SHIter/');
addpath('./IterativeDeblur/');
Sparse_SIM_recon;
