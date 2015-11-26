# encoding: UTF-8
require 'spec_helper'
require 'pp'


RSpec.describe "C++ abstract class wizard", :abstract, :cpp, :class do
  let (:filename) { "test.cpp" }

  before :each do
    vim.command('filetype plugin on')
    vim.command("file #{filename}")
    vim.set('ft=cpp')
    vim.set('expandtab')
    vim.set('sw=4')
    vim.command('silent! unlet g:cpp_explicit_default')
    vim.command('silent! unlet g:cpp_std_flavour')
    clear_buffer
    expect(vim.echo('lh#mut#dirs#get_templates_for("cpp/abstract-class")')).to match(/abstract-class.template/)
  end

  specify "abstract-class noncopyable, with implicit definitions", :cpp98, :cpp11, :noncopyable do
    vim.command('silent! unlet g:cpp_noncopyable_class')
    expect(vim.command('MuTemplate cpp/abstract-class')).to eq ""
    assert_buffer_contents <<-EOF
    #include <boost/noncopyable.hpp>
    class «Test» : private boost::noncopyable
    {
    public:

        /**
         * Virtual destructor.
         * @throw Nothing
         */
        virtual ~«Test»() = 0;

    protected:

        /**
         * Default constructor.
         * «@throw »
         */
        «Test»();
    };
    EOF
  end

  specify "abstract-class noncopyable, no implicit definitions", :cpp11, :noncopyable, :defaulted do
    vim.command('silent! unlet g:cpp_noncopyable_class')
    vim.command("let g:cpp_std_flavour = 11")
    vim.command("let g:cpp_explicit_default = 1")
    expect(vim.command('MuTemplate cpp/abstract-class')).to eq ""
    assert_buffer_contents <<-EOF
    #include <boost/noncopyable.hpp>
    class «Test» : private boost::noncopyable
    {
    public:

        /**
         * Virtual destructor.
         * @throw Nothing
         */
        virtual ~«Test»() = 0;

    protected:

        «Test»() = default;

    private:

        «Test»(«Test» const&) = delete;
        «Test»& operator=(«Test» const&) = delete;
    };
    EOF
  end

  specify "abstract-class C++98 alone", :cpp98, :deleted do
    vim.command('let g:cpp_noncopyable_class=""')
    vim.command('let g:cpp_std_flavour = 03')
    expect(vim.command('MuTemplate cpp/abstract-class')).to eq ""
    assert_buffer_contents <<-EOF
    class «Test»
    {
    public:

        /**
         * Virtual destructor.
         * @throw Nothing
         */
        virtual ~«Test»() = 0;

    protected:

        /**
         * Default constructor.
         * «@throw »
         */
        «Test»();

    private:

        «Test»(«Test» const&) /* = delete */;
        «Test»& operator=(«Test» const&) /* = delete */;
    };
    EOF
  end

  specify "abstract-class C++11 alone, w/ implicit definition", :cpp11, :deleted do
    vim.command('let g:cpp_noncopyable_class = ""')
    vim.command('let g:cpp_std_flavour = 11')
    expect(vim.command('MuTemplate cpp/abstract-class')).to eq ""
    assert_buffer_contents <<-EOF
    class «Test»
    {
    public:

        /**
         * Virtual destructor.
         * @throw Nothing
         */
        virtual ~«Test»() = 0;

    protected:

        /**
         * Default constructor.
         * «@throw »
         */
        «Test»();

    private:

        «Test»(«Test» const&) = delete;
        «Test»& operator=(«Test» const&) = delete;
    };
    EOF
  end

  specify "abstract-class C++11 alone, no implicit definitions", :cpp11, :deleted, :defaulted do
    vim.command('let g:cpp_noncopyable_class = ""')
    vim.command('let g:cpp_std_flavour = 11')
    vim.command("let g:cpp_explicit_default = 1")
    expect(vim.command('MuTemplate cpp/abstract-class')).to eq ""
    assert_buffer_contents <<-EOF
    class «Test»
    {
    public:

        /**
         * Virtual destructor.
         * @throw Nothing
         */
        virtual ~«Test»() = 0;

    protected:

        «Test»() = default;

    private:

        «Test»(«Test» const&) = delete;
        «Test»& operator=(«Test» const&) = delete;
    };
    EOF
  end


end

# vim:set sw=2:
