/**
* Copyright 2014 NVIDIA Corporation.  All rights reserved.
*
* Please refer to the NVIDIA end user license agreement (EULA) associated
* with this source code for terms and conditions that govern your use of
* this software. Any use, reproduction, disclosure, or distribution of
* this software and related documentation outside the terms of the EULA
* is strictly prohibited.
*
*/

/**Modified, updated and re-oragnized some part of codes 
* by Dr. Yingfeng Yu, CUEB, School of Finance,
* last modified Jul,4th,2016
* Only for education purpose
*/

#include "cuda.h"
#include "stdio.h"
#include "stdlib.h"

const int OPT_N = 6400000;

const int  NUM_ITERATIONS = 10;

const int          OPT_SZ = OPT_N * sizeof(float);
const float      RISKFREE = 0.02f;
const float    VOLATILITY = 0.30f;

#define DIV_UP(a, b) ( ((a) + (b) - 1) / (b) )

float RandFloat(float low, float high)
{
    float t = (float)rand() / (float)RAND_MAX;
    return (1.0f - t) * low + t * high;
}

__device__ inline float cndGPUv1(float d)
{//written by Dr.Yingfeng Yu
    
    float cnd;
    cnd=normcdff(d);
    return cnd;
}

__device__ inline float cndGPUv2(float d)
{//Nvidia's code
    const float       A1 = 0.31938153f;
    const float       A2 = -0.356563782f;
    const float       A3 = 1.781477937f;
    const float       A4 = -1.821255978f;
    const float       A5 = 1.330274429f;
    const float RSQRT2PI = 0.39894228040143267793994605993438f;

    float K, cnd;

    K = __fdividef(1.0f, (1.0f + 0.2316419f * fabsf(d)));

    cnd = RSQRT2PI * __expf(- 0.5f * d * d) * (K * (A1 + K * (A2 + K * (A3 + K * (A4 + K * A5)))));

    if (d > 0)
        cnd = 1.0f - cnd;
    return cnd;
}

__device__ inline float pndGPU(float d)
{//written by Dr.Yingfeng Yu
    const float PI = 3.141592653589793238462643f;
    float pnd;
    pnd= (rsqrtf(2.0f*PI))*__expf(-0.5f*d*d);
    return pnd;
}


__device__ inline void BlackScholesBodyGPU(
    float &CallResult,
    float &PutResult,
    float &DeltaCall, //new added by yyf
    float &Gamma,//new added by yyf 
    float S, //Stock price
    float X, //Option strike
    float T, //Option years
    float R, //Riskless rate
    float V  //Volatility rate
)
{
    float sqrtT, expRT;
    float d1, d2,CNDD1, CNDD2;

    sqrtT = __fdividef(1.0F, rsqrtf(T));
    d1 = __fdividef(__logf(S / X) + (R + 0.5f * V * V) * T, V * sqrtT);
    d2 = d1 - V * sqrtT;

    CNDD1 = cndGPUv1(d1);// it is better to use my version
    CNDD2 = cndGPUv1(d2);

    //Calculate Call and Put simultaneously
    expRT = __expf(- R * T);
    CallResult = S * CNDD1 - X * expRT * CNDD2;
    PutResult  = X * expRT * (1.0f - CNDD2) - S * (1.0f - CNDD1);
    DeltaCall = pndGPU(d1);
    Gamma = __fdividef(pndGPU(d1),V*S*sqrtT);
}


////////////////////////////////////////////////////////////////////////////////
//Process an array of optN options on GPU
////////////////////////////////////////////////////////////////////////////////
__launch_bounds__(128)
__global__ void BlackScholesGPU(
    float * d_CallResult,
    float * d_PutResult,
    float * d_DeltaCall,
    float * d_Gamma,
    float * d_StockPrice,
    float * d_OptionStrike,
    float * d_OptionYears,
    float Riskfree,
    float Volatility,
    int optN
)
{
    const int opt = blockDim.x * blockIdx.x + threadIdx.x;
    float callResult, putResult, deltaCall, gamma;//add yyf

    BlackScholesBodyGPU(
            callResult,
            putResult,
            deltaCall,
            gamma,
            d_StockPrice[opt],
            d_OptionStrike[opt],
            d_OptionYears[opt],
            Riskfree,
            Volatility);
        d_CallResult[opt] = callResult;
        d_PutResult[opt] = putResult;
        d_DeltaCall[opt] = deltaCall;
        d_Gamma[opt] = gamma;
}


////////////////////////////////////////////////////////////////////////////////
// Main program
////////////////////////////////////////////////////////////////////////////////
int main(int argc, char **argv)
{
    printf("[%s] - Starting...\n", argv[0]);

    float
        *h_CallResult,
        *h_PutResult,
        *h_DeltaCall,
        *h_Gamma,
        //CPU instance of input data
        *h_StockPrice,
        *h_OptionStrike,
        *h_OptionYears;

    float
    //Results calculated by GPU
        *d_CallResult,
        *d_PutResult,
        *d_DeltaCall,
        *d_Gamma,
    //GPU instance of input data
        *d_StockPrice,
        *d_OptionStrike,
        *d_OptionYears;

    int i;

    printf("Initializing data...\n");

    h_CallResult   =   (float *)malloc(OPT_SZ);
    h_PutResult   =   (float *)malloc(OPT_SZ);
    h_DeltaCall     =   (float *)malloc(OPT_SZ);
    h_Gamma       =   (float *)malloc(OPT_SZ);
    h_StockPrice           =   (float *)malloc(OPT_SZ);
    h_OptionStrike      =   (float *)malloc(OPT_SZ);
    h_OptionYears       =   (float *)malloc(OPT_SZ);

    printf("...allocating GPU memory for options.\n");
    cudaMalloc( (void **)    &d_CallResult,          OPT_SZ);
    cudaMalloc( (void **)    &d_PutResult,          OPT_SZ);
    cudaMalloc( (void **)    &d_DeltaCall,            OPT_SZ);
    cudaMalloc( (void **)    &d_Gamma,              OPT_SZ);
    cudaMalloc( (void **)    &d_StockPrice,         OPT_SZ);
    cudaMalloc( (void **)    &d_OptionStrike,    OPT_SZ);
    cudaMalloc( (void **)    &d_OptionYears,     OPT_SZ);

    printf("...generating input data in CPU mem.\n");
    srand(5347);

    //Generate options set
    for (i = 0; i < OPT_N; i++)
    {
        h_StockPrice[i]     =       RandFloat(5.0f, 30.0f);
        h_OptionStrike[i]  =      RandFloat(1.0f, 100.0f);
        h_OptionYears[i]   =      RandFloat(0.25f, 10.0f);
    }

    printf("...copying input data to GPU mem.\n");
    //Copy options data to GPU memory for further processing
    cudaMemcpy(d_StockPrice,  h_StockPrice,   OPT_SZ, cudaMemcpyHostToDevice);
    cudaMemcpy(d_OptionStrike, h_OptionStrike,  OPT_SZ, cudaMemcpyHostToDevice);
    cudaMemcpy(d_OptionYears,  h_OptionYears,   OPT_SZ, cudaMemcpyHostToDevice);
    printf("Data init done.\n\n");


    printf("Executing Black-Scholes GPU kernel (%i iterations)...\n", NUM_ITERATIONS);
    cudaDeviceSynchronize();

    for (i = 0; i < NUM_ITERATIONS; i++)
    {
            printf("Now executing Black-Scholes GPU kernel (%i -th)...\n", i);
        BlackScholesGPU<<<DIV_UP(OPT_N, 128), 128/*480, 128*/>>>(
            d_CallResult,
            d_PutResult,
            d_DeltaCall, //new added by yyf
            d_Gamma,//new added  by yyf
            d_StockPrice,
            d_OptionStrike,
            d_OptionYears,
            RISKFREE,
            VOLATILITY,
            OPT_N
        );
    }

    cudaDeviceSynchronize();
    cudaMemcpy(h_CallResult, d_CallResult, OPT_SZ, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_PutResult,  d_PutResult,  OPT_SZ, cudaMemcpyDeviceToHost);
    cudaMemcpy(h_DeltaCall,  d_DeltaCall,  OPT_SZ, cudaMemcpyDeviceToHost);
     cudaMemcpy(h_Gamma,  d_Gamma,  OPT_SZ, cudaMemcpyDeviceToHost);

    int NN=20;
    printf("===============================================Basic Info===============================================\n");
    printf("\t\t\tTotal Num.of Options=%d,\n\t\t\tRisk-free rate Rf=%f,\n\t\t\tVolatility(Sigma)=%f.\n",OPT_N,RISKFREE,VOLATILITY);
    printf("\t\t\tCopyright belongs to Nvidia, modified by Dr. Yingfeng Yu. \n\t\t\tFor education purpose only.\n" );
    printf("=====================CUDA Results========================================||=====BSM's other Info========\n");
    printf("The index    |\tCall Price    |\t Put Price    |\tCall Delta|\tGamma\t ||         (S,K,T)\n");

    for (i = 0; i < NN; i++)
    {
       printf("[%d]\t\t %f\t %f\t %f\t %f||(%f,%f,%f)\n",i+1,
            h_CallResult[i],h_PutResult[i],
            h_DeltaCall[i],h_Gamma[i],
            h_StockPrice[i],h_OptionStrike[i],h_OptionYears[i]);
    }
    printf(".\n");
    printf(".\n");
    printf(".\n");

    for (i = OPT_N-NN; i < OPT_N; i++)
    {
        printf("[%d]\t %f\t %f\t %f\t %f||(%f,%f,%f)\n",i+1,
            h_CallResult[i],h_PutResult[i],
            h_DeltaCall[i],h_Gamma[i],
            h_StockPrice[i],h_OptionStrike[i],h_OptionYears[i]);
    }
    
    printf("...releasing GPU memory.\n");
    cudaFree(d_OptionYears);
    cudaFree(d_OptionStrike);
    cudaFree(d_StockPrice);
    cudaFree(d_PutResult);
    cudaFree(d_CallResult);
    cudaFree(d_DeltaCall);
    cudaFree(d_Gamma);

    printf("...releasing CPU memory.\n");
    free(h_OptionYears);
    free(h_OptionStrike);
    free(h_StockPrice);
    free(h_PutResult);
    free(h_CallResult);
    free(h_DeltaCall);
    free(h_Gamma);

    printf("All testing, .... done.\n");
    cudaDeviceReset();
}
