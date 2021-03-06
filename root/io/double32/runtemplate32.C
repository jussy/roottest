#include "runtemplate32.h"

#ifdef __MAKECINT__
#pragma link C++ class WithDouble+;
#pragma link C++ class MyVector<Double32_t>+;
#pragma link C++ class MyVector<float>+;
// #pragma link C++ class MyVector<double>+;
#endif

int runtemplate32 ()
{
   gROOT->ProcessLine(".L other.C+");
   gROOT->GetClass("WithDouble")->GetStreamerInfo()->ls();
   gROOT->GetClass("MyVector<double>")->GetStreamerInfo()->ls();
   gROOT->GetClass("MyVector<Double32_t>")->GetStreamerInfo()->ls();
   gROOT->GetClass("Contains")->GetStreamerInfo()->ls();
   gROOT->GetClass("Contains")->GetListOfRealData()->ls();

   
   TRealData *r = (TRealData*)gROOT->GetClass("Contains")->GetListOfRealData()->At(1);
   cout << "The following should be a Double32_t: " << r->GetDataMember()->GetTypeName() << endl;
   TFile *f = new TFile("double32.root","RECREATE");
   Contains *c = new Contains;
   f->WriteObject(c,"myobj");
   delete f;
   return 0;
}
