void build(const char *filename,const char *lib = 0, const char *obj = 0) 
{
   if (obj!=0 && strlen(obj) ) {
      TString s = gSystem->GetMakeSharedLib();
      TString r(" $ObjectFiles ");
      r.Append(obj);
      s.ReplaceAll(" $ObjectFiles",r);
      //gDebug = 5;
      gSystem->SetMakeSharedLib(s);
   }
   if (lib && strlen(lib)) {
      TString liblist(lib);
      TObjArray *libs = liblist.Tokenize(" ");
      TIter iter(libs);
      TObjString *objstr;

      TString s = gSystem->GetMakeSharedLib();
      TString what("..nothing..");
      if (s.Contains("$DepLibs")) {
         what = " $DepLibs";
      } else {
         what = " $LinkedLibs";
      }
      TString libstolink(" ");
      while ( (objstr=(TObjString*)iter.Next()) ) {
         gSystem->Load(objstr->String());
         TString libfile( gSystem->GetLibraries(objstr->String(),"DSL",kFALSE));
         libstolink.Append(libfile);
         libstolink.Append(" ");
      }
      libstolink.Append(what);
      s.ReplaceAll(what,libstolink);
      gSystem->SetMakeSharedLib(s);
   }
#ifdef __CLING__
   TString r;
#ifdef  ClingWorkAroundCallfuncAndInline
   r.Append(" -DClingWorkAroundCallfuncAndInline ");
#endif
#ifdef  ClingWorkAroundCallfuncAndVirtual
   r.Append(" -DClingWorkAroundCallfuncAndVirtual ");
#endif
#ifdef ClingWorkAroundJITandInline
   r.Append(" -DClingWorkAroundJITandInline ");
#endif
#ifdef ClingWorkAroundCallfuncAndReturnByValue
   r.Append(" -DClingWorkAroundCallfuncAndReturnByValue ");
#endif
#ifdef ClingWorkAroundNoPrivateClassIO
   r.Append(" -DClingWorkAroundNoPrivateClassIO ");
#endif
   if (r.Length()) {
      r.Append(" $IncludePath");
      TString s = gSystem->GetMakeSharedLib();
      s.ReplaceAll(" $IncludePath",r);
      gSystem->SetMakeSharedLib(s);
   }
#endif
      
#if defined(_WIN32) && !defined(__CYGWIN__)
   TString fname(filename);
   if (filename[0]=='/') {
     // full path name we need to turn it into a windows path
     fname = gSystem->GetFromPipe(TString::Format("cygpath -w %s",filename));
   }
   fprintf(stderr,"from %s to %s\n",filename,fname.Data());
   int result = gSystem->CompileMacro(fname,"kc");
#else
   int result = gSystem->CompileMacro(filename,"kc");
#endif
   if (!result) gApplication->Terminate(1);
}

