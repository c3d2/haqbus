%%% Modification of BibTeX style file gerplain.bst
%%% ... by urlbst, version 0.4-1 (marked with "% urlbst")
%%% See <http://www.astro.gla.ac.uk/users/norman/distrib/urlbst/>
%%% Added webpage entry type, and url and lastchecked fields.
%%% Added eprint support.
%%% Original headers follow...

% BibTeX standard bibliography style `plain'
        % version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
        % Copyright (C) 1985, all rights reserved.
        % Copying of this file is authorized only if either
        % (1) you make absolutely no changes to your copy, including name, or
        % (2) if you do make changes, you name it something other than
        % btxbst.doc, plain.bst, unsrt.bst, alpha.bst, and abbrv.bst.
        % This restriction helps ensure that all standard styles are identical.
        % The file btxbst.doc has the documentation for this style.
%   15-feb-92   (MW)    Updated for use with `bibgerman.sty': things like "and"
%                       change with the language. Switch the language using the
%                       language field: 
%                          language = "german" | "USenglish" | "english"
%                       Then a `\selectlanguage{...}' command will be pushed just
%                       before the `\bibitem...' command for the entry in work.

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    language
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    eprint % urlbst
    url % urlbst
    lastchecked % urlbst
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block before.title }

STRINGS { s t language.state language.temp }

STRINGS { urlintro eprinturl eprintprefix } % urlbst...
INTEGERS { hrefform addeprints }
% Following constants may be adjusted by hand, if desired
FUNCTION {init.config.constants}
{
  "URL: " 'urlintro :=  % prefix before URL
  "http://arxiv.org/abs/" 'eprinturl :=  % prefix to make URL from eprint ref
  "arXiv:" 'eprintprefix := % text prefix printed before eprint ref
  #0 'addeprints := % 0=no eprints; 1=include eprints
  #0 'hrefform := % 0=no crossrefs; 1=hypertex xrefs; 2=hyperref refs
}
INTEGERS { 
  bracket.state
  outside.brackets
  open.brackets
  within.brackets
  close.brackets
}
% ...urlbst to here
FUNCTION {init.state.consts}
{ #0 'outside.brackets := % urlbst
  #1 'open.brackets :=
  #2 'within.brackets :=
  #3 'close.brackets :=

  #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'before.title :=
  "nostate" 'language.state :=
}

FUNCTION {language.state.test}
{ 
  'language.temp :=
  language.temp language.state =
    { #1 }
    { #0 }
  if$
}


FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

% urlbst
FUNCTION {output.nonnull.original}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            % next if is for use with `new' FUNCTION {after.authors}
            { output.state before.title =
                { ": " * write$ }
                { add.period$ " " * write$ }
              if$
            }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

% urlbst...
FUNCTION {output.nonnull}
{ % Save the thing we've been asked to output
  's :=
  % If the bracket-state is close.brackets, then add a close-bracket to
  % what is currently at the top of the stack, and set bracket.state
  % to outside.brackets
  bracket.state close.brackets =
    { "]" *
      outside.brackets 'bracket.state :=
    }
    'skip$
  if$
  bracket.state outside.brackets =
    { % We're outside all brackets -- this is the normal situation.
      % Write out what's currently at the top of the stack, using the
      % original output.nonnull function.
      s
      output.nonnull.original
    }
    { % Still in brackets.  Add open-bracket or (continuation) comma, add the
      % new text (in s) to the top of the stack, and move to the close-brackets
      % state, ready for next time (unless inbrackets resets it).  If we come
      % into this branch, then output.state is carefully undisturbed.
      bracket.state open.brackets =
        { " [" * }
        { ", " * } % bracket.state will be within.brackets
      if$ 
      s * 
      close.brackets 'bracket.state :=
    }
  if$
}

% Call this function just before adding something which should be presented in 
% brackets.  bracket.state is handled specially within output.nonnull.
FUNCTION {inbrackets}
{ bracket.state close.brackets =
    { within.brackets 'bracket.state := } % reset the state: not open nor closed
    { open.brackets 'bracket.state := }
  if$
}

FUNCTION {format.lastchecked}
{ lastchecked empty$
    { "" }
    { inbrackets "cited " lastchecked * }
  if$
}
% ...urlbst to here

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.bibitem}
{ outside.brackets 'bracket.state := % urlbst
   newline$
  language empty$
    'skip$
    { language.state language =
        'skip$
        { "\selectlanguage{\" language * "}" * write$
          newline$
        }
      if$
      language 'language.state :=
    }
  if$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ 
  bracket.state close.brackets = % urlbst
    { "]" * }
    'skip$
  if$
   add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

% new one -> sets what is specified in FUNCTION {output.nonnull}
% if `before.title 'output.state = ... if$' is true
FUNCTION {after.authors}
{ output.state before.all =
    'skip$
    { before.title 'output.state := }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkc}
{ empty$
  swap$ empty$
  and
    'skip$
    'after.authors
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {smallcaps}
{ duplicate$ empty$
    { pop$ "" }
    { "{\sc " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ smallcaps 't :=
          namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { "english" language.state.test
                  "USenglish" language.state.test
                  or
                     {"," * }
                     'skip$
                  if$
                }
                'skip$
              if$
              t "others" =
                { " \btxetalshort{.}" * }
                { " \btxandlong{}\ " * t * }
              if$
            }
          if$
        }
        { s nameptr "{ll}{, jj}{, ff}{~vv}" format.name$ smallcaps }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { "\ (\btxeditorslong{})" * }
        { "\ (\btxeditorlong{})" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { "english" language.state.test
      "USenglish" language.state.test
      or
        { title "t" change.case$ emphasize }
        { title emphasize }
      if$
    }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
        { "" }
        { "there's a month but no year in " cite$ * warning$
          month
        }
      if$
    }
    { month empty$
        'year
        { month " " * year * }
      if$
    }
  if$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { "\ " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { output.state after.block =
        { "\Btxvolumelong{}" }
        { "\btxvolumelong{}" }
      if$
      volume tie.or.space.connect
      series empty$
        'skip$
        { " \btxofserieslong{}\ " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "\btxnumberlong{}" }
            { "\Btxnumberlong{}" }
          if$
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " cite$ * warning$ }
            { " \btxinserieslong{}\ " * series emphasize * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { "english" language.state.test
      "USenglish" language.state.test
      or
        { output.state mid.sentence =
            { edition "l" change.case$ " \btxeditionlong{}" * }
            { edition "t" change.case$ " \btxeditionlong{}" * }
          if$
        }
        { edition " \btxeditionlong{}" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { "\btxpageslong{}" pages n.dashify tie.or.space.connect }
        { "\btxpagelong{}" pages tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ":" * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
        { "\btxchapterlong{}" }
        { "english" language.state.test
          "USenglish" language.state.test
          or
             { type "l" change.case$ }
             { type }
         if$
        }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "\Btxinlong{}\ " booktitle emphasize * }
        { "\Btxinlong{}\ " format.editors * ": " * booktitle emphasize * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      "english" language.state.test
      "USenglish" language.state.test
      or
        { type "t" change.case$ }
        { type }
      if$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "\Btxtechreplong{}" }
    'type
  if$
  number empty$
    { "english" language.state.test
      "USenglish" language.state.test
      or
        { type empty$
            { pop$ "\btxtechreplong{}" }
            { "t" change.case$ }
          if$
        }
        'skip$
      if$
    }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
        { "need key or journal for " cite$ * " to crossref " * crossref *
          warning$
          ""
        }
        { "\Btxinlong{}\ " journal emphasize * }
      if$
    }
    { "\Btxinlong{}\ " key emphasize * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{ll}{, jj}{, ff}{~vv}" format.name$ smallcaps
  editor num.names$ duplicate$
  #2 >
    { pop$ " \btxetalshort{.}" * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " \btxetalshort{.}" * }
            { " \btxandlong{}\ " * editor #2 "{ff}{~vv}{~ll}{, jj}" format.name$ smallcaps * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "\Btxinlong{}\ "
    }
    { "\Btxvolumelong{}" volume tie.or.space.connect
      " \btxofserieslong{}\ " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "need editor, key, or series for " cite$ * " to crossref " *
              crossref * warning$
              "" *
            }
            { series emphasize * }
          if$
        }
        { key emphasize * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "need editor, key, or booktitle for " cite$ * " to crossref " *
              crossref * warning$
              ""
            }
            { "\Btxinlong{}\ " booktitle emphasize * }
          if$
        }
        { "\Btxinlong{}\ " key emphasize * }
      if$
    }
    { "\Btxinlong{}\ " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

% urlbst...
% Functions for making hypertext links.
% In all cases, the stack has (link-text href-url)
%
% make 'null' specials
FUNCTION {make.href.null}
{
  pop$
}
% make hypertex specials
FUNCTION {make.href.hypertex}
{ 
  "\special {html:<a href=" quote$ *
  swap$ * quote$ * "> }" * swap$ *
  "\special {html:</a>}" *
}
% make hyperref specials
FUNCTION {make.href.hyperref}
{ 
  "\href {" swap$ * "} {" * swap$ * "}" *
}
FUNCTION {make.href}
{ hrefform #2 =
    'make.href.hyperref      % hrefform = 2
    { hrefform #1 =
        'make.href.hypertex  % hrefform = 1
        'make.href.null      % hrefform = 0 (or anything else)
      if$
    }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
      { hrefform #1 =
          { % special case -- add HyperTeX specials
            urlintro "\url{" url * "}" * url make.href.hypertex * }
          { urlintro "\url{" * url * "}" * }
       if$
     }
  if$
}

FUNCTION {format.eprint}
{ eprint empty$
    { "" }
    { eprintprefix eprint * eprinturl eprint * make.href }
  if$
}

% Output a URL.  We can't use the more normal idiom (something like
% `format.url output'), because the `inbrackets' within
% format.lastchecked applies to everything between calls to `output',
% so that `format.url format.lastchecked * output' ends up with both
% the URL and the lastchecked in brackets.
FUNCTION {output.url}
{ url empty$
    'skip$ 
    { new.block 
      format.url output
      format.lastchecked output 
    }
  if$
}

FUNCTION {output.web.refs}
{
  new.block
  output.url
  addeprints eprint empty$ not and
    { format.eprint output.nonnull }
    'skip$
  if$
%  addeprints
%    { eprint empty$
%        'skip$
%        { format.eprint output.nonnull }
%      if$
%    }
%    'skip$
%  if$
}

% Webpage entry type.
% Title and url fields required;
% author, note, year, month, and lastchecked fields optional
% See references 
%   ISO 690-2 http://www.nlc-bnc.ca/iso/tc46sc9/standard/690-2e.htm
%   http://www.classroom.net/classroom/CitingNetResources.html
%   http://neal.ctstateu.edu/history/cite.html
%   http://www.cas.usf.edu/english/walker/mla.html
% for citation formats for web pages.
FUNCTION {webpage}
{ output.bibitem
  author empty$
    { editor empty$
        'skip$  % author and editor both optional
        { format.editors output.nonnull }
      if$
    }
    { editor empty$
        { format.authors output.nonnull }
        { "can't use both author and editor fields in " cite$ * warning$ }
      if$
    }
  if$
%  author empty$
%    'skip$
%    { format.authors output.nonnull }
%  if$
  new.block
  format.title "title" output.check
  inbrackets "online" output
  new.block
  year empty$
    'skip$
    { format.date "year" output.check }
  if$
  lastchecked empty$
    'skip$
    { format.lastchecked output }
  if$
  new.block
  format.url "url" output.check
  new.block
  note output
  fin.entry
}
% ...urlbst to here


FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title "title" output.check
  new.block
  crossref missing$
    { journal 
      title missing$
        { emphasize }
        'skip$
      if$
      "journal" output.check 
      format.vol.num.pages output
      format.date "year" output.check
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  after.authors
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  after.authors
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  after.authors
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      format.chapter.pages "chapter and pages" output.check
      new.block
      format.number.series output
      new.sentence
      publisher "publisher" output.check
      address output
    }
    { format.chapter.pages "chapter and pages" output.check
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.chapter.pages output
      new.sentence
      publisher "publisher" output.check
      address output
      format.edition output
      format.date "year" output.check
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.pages output
      address empty$
        { organization publisher new.sentence.checkb
          organization output
          publisher output
          format.date "year" output.check
        }
        { address output.nonnull
          format.date "year" output.check
          new.sentence
          organization output
          publisher output
        }
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization smallcaps output.nonnull
          address output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  after.authors
  format.btitle "title" output.check
  author empty$
    { organization empty$
        { address new.block.checka
          address output
        }
        'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title "title" output.check
  new.block
  "\btxmastthesis{}" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkc
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.btitle "title" output.check
  new.block
  "\btxphdthesis{}" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization smallcaps output }
    { format.editors output.nonnull }
  if$
  after.authors
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
        { publisher new.sentence.checka }
        { organization publisher new.sentence.checkb
          organization output
        }
      if$
      publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      editor empty$
        'skip$
        { organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  after.authors
  format.title "title" output.check
  new.block
  note "note" output.check
  format.date output
  output.web.refs  % urlbst
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"\btxmonjanlong{}"}

MACRO {feb} {"\btxmonfeblong{}"}

MACRO {mar} {"\btxmonmarlong{}"}

MACRO {apr} {"\btxmonaprlong{}"}

MACRO {may} {"\btxmonmaylong{}"}

MACRO {jun} {"\btxmonjunlong{}"}

MACRO {jul} {"\btxmonjullong{}"}

MACRO {aug} {"\btxmonauglong{}"}

MACRO {sep} {"\btxmonseplong{}"}

MACRO {oct} {"\btxmonoctlong{}"}

MACRO {nov} {"\btxmonnovlong{}"}

MACRO {dec} {"\btxmondeclong{}"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * }
        'skip$
      if$
      s nameptr "{ll{ }}{  ff{ }}{vv{ } }{  jj{ }}" format.name$ smallcaps 't :=
      nameptr numnames = t "others" = and
        { "et al" * }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.organization.sort
        { type$ "manual" =
            'author.organization.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.config.constants}
EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
