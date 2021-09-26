%***************************************************************************
%                                 Spare-SIM GUI.
% *********************************************************************************
% This software package is It is an universal post-processing framework for 
% fluorescent (or intensity-based) image restoration, including 
% xy (2D), xy-t (2D along t axis), and xy-z (3D) images. 
% It is based on the natural priori knowledge of forward fluorescent 
% imaging model: sparsity and continuity along xy-t(z) axes. 
% *********************************************************************************
% Sparse deconvolution algorithm GUI v1.0.3
% *********************************************************************************
%% It is able to run under Unix-like OS, and should be modified for the Windows OS.
% ------------------------------------------------------------------------------------------------
% argmin_g { ||f-b-g ||_2^2 +||gxx||_1+||gxx||_1+||gyy||_1+lamdbaz*||gzz||_1+2*||gxy||_1
%  +2*sqrt(lamdbaz)||gxz||_1+ 2*sqrt(lamdbaz)|||gyz||_1+2*sqrt(lamdbal1)|||g||_1}
% *********************************************************************************
% Written by WeisongZhao @ zhaoweisong950713@163.com
% if any bugs is found, please just email me or put an issue on the github.
% *********************************************************************************
% https://weisongzhao.github.io/Sparse-SIM/
% *********************************************************************************
% It is a part of publication:
% Weisong Zhao et al. Sparse deconvolution improves the resolution of live-cell
% super-resolution fluorescence microscopy, Nature Biotechnology, X, XXX-XXX (2021).
% https://doi.org/10.1038/s41587-021-01092-2
% *********************************************************************************
%    Copyright 2018~2021 Weisong Zhao et al.
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the Open Data Commons Open Database License v1.0.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%    Open Data Commons Open Database License for more details.
%
%    You should have received a copy of the 
%    Open Data Commons Open Database License
%    along with this program.  If not, see:
%    <https://opendatacommons.org/licenses/odbl/>.
%***************************************************************************
clc;clear;close all;warning off;
addpath('./Utils/');
addpath('./SHOperation/');
addpath('./SHIter/');
addpath('./IterativeDeblur/');
Sparse_SIM_recon;
