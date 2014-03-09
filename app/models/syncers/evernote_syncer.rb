class EvernoteSyncer < Syncer

  EVERNOTE_STACK = "Mod Notebooks"
  EVERNOTE_TAGS  = ["Mod Notebook"]

  def sync
    pages = notebook.pages.find_all { |p| needs_sync?(p) }

    unless pages.empty?
      guid = evernotebook_guid(notebook)

      guid.try do |en|
        notebook.update(evernote_guid: guid)

        pages.each do |page|
          sync_page(page, guid)
        end
      end
    end
  end

  def sync_page(page, guid)
    enote = note(page)
    enote.notebookGuid = guid

    success = service.with_api(on_rescue: false) do |api|
      api.note_store.createNote(enote)
    end

    !!success ? mark_synced(page) : mark_unsynced(page)
  end

  private
    def evernotebook_guid(notebook)
      existing = existing_evernotebooks.collect(&:guid)

      existing_guid = notebook.evernote_guid
      return existing_guid if (existing_guid && existing.include?(existing_guid))

      enotebook = Evernote::EDAM::Type::Notebook.new(
        name: evernotebook_name(notebook),
        stack: EVERNOTE_STACK
      )

      service.with_api(on_rescue: nil) do |api|
        api.note_store.createNotebook(enotebook).guid
      end
    end

    def evernotebook_name(notebook)
      existing = existing_evernotebooks.inject([]) { |memo, en|
        memo << en.name.downcase; memo }

      name     = notebook.name
      date     = notebook.submitted_on || notebook.created_at

      name << " - #{date.strftime('%b %-d, %Y')}" if existing.include?(name.downcase)
      name
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

    def existing_evernotebooks
      @evernotebooks ||= service.with_api(on_rescue: []) do |api|
        api.note_store.listNotebooks
      end
    end

    def filename(page)
      "page#" << "%03d" % page.index << ".jpg"
    end

    def note_body(file_digest)
      %Q[
      <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
          <en-note>
            <en-media type="image/jpg" hash="#{file_digest}"/>
          </en-note>
      ].strip
    end
end
