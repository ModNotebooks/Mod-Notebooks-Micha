class EvernoteSyncer < Syncer

  EVERNOTE_STACK = "Mod Notebooks"
  EVERNOTE_TAGS  = ["Mod Notebook"]

  def sync
    pages = notebook.pages.find_all { |p| needs_sync?(p) }

    unless pages.empty?
      enotebook = evernotebook(notebook)

      enotebook.try do |en|
        pages.each do |page|
          sync_page(page, enotebook)
        end
      end
    end
  end

  def sync_page(page, evernotebook)
    enote = note(page)
    enote.notebookGuid = evernotebook.guid

    success = service.with_api(on_rescue: false) do |api|
      api.note_store.createNote(enote)
    end

    !!success ? mark_synced(page) : mark_unsynced(page)
  end

  private
    def evernotebook(notebook)
      existing = existing_evernotebooks
      enotebook = nil

      enotebook = existing.detect { |en| en.name.downcase == notebook.name.downcase }
      return enotebook if enotebook

      enotebook       = Evernote::EDAM::Type::Notebook.new
      enotebook.name  = notebook.name
      enotebook.stack = EVERNOTE_STACK

      service.with_api(on_rescue: nil) do |api|
        api.note_store.createNotebook(enotebook)
      end
    end

    def note(page)
      image = page.image.versions[:large]
      enote = Evernote::EDAM::Type::Note.new

      enote.tap do |en|
        en.title = "Page #" << "%03d" % page.index
        en.tagNames = EVERNOTE_TAGS
        file_digest = en.add_resource(filename(page), image.read, 'image/jpeg')
        en.content = note_body(file_digest)
      end
    end

    def filename(page)
      "page#" << "%03d" % page.index << ".jpg"
    end

    def existing_evernotebooks
      evernotebooks = service.with_api(on_rescue: []) do |api|
        api.note_store.listNotebooks
      end
    end

    def note_body(file_digest)
      %q[
      <?xml version='1.0' encoding='UTF-8'?>
        <!DOCTYPE en-note SYSTEM 'http://xml.evernote.com/pub/enml2.dtd'>
          <en-note>
            <en-media type='image/jpg' hash='#{file_digest}' width='600' height='600'/>
          </en-note>
      ].strip
    end
end
