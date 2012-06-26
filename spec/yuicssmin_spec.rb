# coding: utf-8

require "spec_helper"


describe "Yuicssmin" do
  
  context "application" do
  
    it "minifies CSS" do
      source = File.open(File.expand_path("../sample.css", __FILE__), "r:UTF-8").read
      minified = Yuicssmin.compress(source)
      minified.length.should < source.length
      lambda {
        Yuicssmin.compress(minified)
      }.should_not raise_error
    end
  
    it "honors the specified maximum line length" do
      source = <<-EOS
        .classname1 {
            border: none;
            background: none;
            outline: none;
        }
        .classname2 {
            border: none;
            background: none;
            outline: none;
        }
      EOS
      minified = Yuicssmin.compress(source, 30)
      minified.split("\n").length.should eq(2)
      minified.should eq(".classname1{border:0;background:0;outline:0}\n.classname2{border:0;background:0;outline:0}")
    end

    it "handles strings as input format" do
      lambda {
        Yuicssmin.compress(File.open(File.expand_path("../sample.css", __FILE__), "r:UTF-8").read).should_not be_empty
      }.should_not raise_error
    end

    it "handles files as input format" do
      lambda {
        Yuicssmin.compress(File.open(File.expand_path("../sample.css", __FILE__), "r:UTF-8")).should_not be_empty
      }.should_not raise_error
    end
    
    it "works as both class and class instance" do
      lambda {
        Yuicssmin.compress(File.open(File.expand_path("../sample.css", __FILE__), "r:UTF-8").read).should_not be_empty
        Yuicssmin.new.compress(File.open(File.expand_path("../sample.css", __FILE__), "r:UTF-8").read).should_not be_empty
      }.should_not raise_error
    end
    
  end
  

  context "compression" do

    it "removes comments and white space" do
      source = <<-EOS
        /*****
          Multi-line comment
          before a new class name
        *****/
        .classname {
            /* comment in declaration block */
            font-weight: normal;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.classname{font-weight:normal}')
    end
  
    it "preserves special comments" do
      source = <<-EOS
        /*!
          (c) Very Important Comment
        */
        .classname {
            /* comment in declaration block */
            font-weight: normal;
        }
      EOS
      minified = Yuicssmin.compress(source)
      result = <<-EOS
/*!
          (c) Very Important Comment
        */.classname{font-weight:normal}
      EOS
      (minified + "\n").should eq(result)
    end

    it "removes last semi-colon in a block" do
      source = <<-EOS
        .classname {
            border-top: 1px;
            border-bottom: 2px;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.classname{border-top:1px;border-bottom:2px}')
    end
  
    it "removes extra semi-colons" do
      source = <<-EOS
        .classname {
            border-top: 1px; ;
            border-bottom: 2px;;;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.classname{border-top:1px;border-bottom:2px}')
    end
  
    it "removes empty declarations" do
      source = <<-EOS
        .empty { ;}
        .nonempty {border: 0;}
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.nonempty{border:0}')
    end
  
    it "simplifies zero values" do
      source = <<-EOS
        a {
            margin: 0px 0pt 0em 0%;
            background-position: 0 0ex;
            padding: 0in 0cm 0mm 0pc
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('a{margin:0;background-position:0 0;padding:0}')
    end
  
    it "removes leading zeros from floats" do
      source = <<-EOS
        .classname {
            margin: 0.6px 0.333pt 1.2em 8.8cm;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.classname{margin:.6px .333pt 1.2em 8.8cm}')
    end
  
    it "simplifies color values but preserves filter properties, RGBa values and ID strings" do
      source = <<-EOS
        .color-me {
            color: rgb(123, 123, 123);
            border-color: #ffeedd;
            background: none repeat scroll 0 0 rgb(255, 0,0);
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.color-me{color:#7b7b7b;border-color:#fed;background:none repeat scroll 0 0 #f00}')

      source = <<-EOS
        #AABBCC {
            color: rgba(1, 2, 3, 4);
            filter: chroma(color="#FFFFFF");
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('#AABBCC{color:rgba(1,2,3,4);filter:chroma(color="#FFFFFF")}')
    end
  
    it "only keeps the first charset declaration" do
      source = <<-EOS
        @charset "utf-8";
        #foo {
            border-width: 1px;
        }

        /* second css, merged */
        @charset "another one";
        #bar {
            border-width: 10px;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('@charset "utf-8";#foo{border-width:1px}#bar{border-width:10px}')
    end
  
    it "simplifies the IE opacity filter syntax" do
      source = <<-EOS
        .classname {
            -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=80)"; /* IE 8 */
            filter: progid:DXImageTransform.Microsoft.Alpha(Opacity=80);       /* IE < 8 */
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.classname{-ms-filter:"alpha(opacity=80)";filter:alpha(opacity=80)}')
    end
  
    it "replaces 'none' values with 0 where allowed" do
      source = <<-EOS
        .classname {
            border: none;
            background: none;
            outline: none;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('.classname{border:0;background:0;outline:0}')
    end
  
    it "tolerates underscore/star hacks" do
      source = <<-EOS
        #element {
            width: 1px;
            *width: 2px;
            _width: 3px;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('#element{width:1px;*width:2px;_width:3px}')
    end
  
    it "tolerates child selector hacks" do
      source = <<-EOS
        html >/**/ body p {
            color: blue;
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('html>/**/body p{color:blue}')
    end
  
    it "tolerates IE5/Mac hacks" do
      source = <<-EOS
        /* Ignore the next rule in IE mac \\*/
        .selector {
            color: khaki;
        }
        /* Stop ignoring in IE mac */
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('/*\*/.selector{color:khaki}/**/')
    end
  
    it "tolerates box model hacks" do
      source = <<-EOS
        #elem {
            width: 100px; /* IE */
            voice-family: "\\"}\\"";
            voice-family:inherit;
            width: 200px; /* others */
        }
        html>body #elem {
            width: 200px; /* others */
        }
      EOS
      minified = Yuicssmin.compress(source)
      minified.should eq('#elem{width:100px;voice-family:"\"}\"";voice-family:inherit;width:200px}html>body #elem{width:200px}')
    end
    
  end
  
end
