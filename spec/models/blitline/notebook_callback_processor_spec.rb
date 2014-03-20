require 'spec_helper'

describe Blitline::NotebookCallbackProcessor do

    context "with a blitline response" do
      let(:response) { JSON(IO.read("#{Rails.root}/spec/files/blitline_burst_pdf_response.json")) }
      let(:notebook) { create(:notebook, pdf: File.open("#{Rails.root}/spec/test_scan.pdf")) }

      it 'should populate pages with response' do
        Blitline::NotebookCallbackProcessor.process(notebook.id, response)
        notebooks.pages.count.to be > 0
      end
    end

end


# IO.read("#{Rails.root}/spec/files/blitline_burst_pdf_response.json")
