class DropboxSyncer < Syncer

  def sync
    pages = notebook.pages.find_all { |p| needs_sync?(p) }

    unless pages.empty?
      folder = folder_name(notebook)

      pages.each do |page|
        file = filename(page)
        path = "#{folder}/#{file}"

        sync_page(path, page)
      end
    end
  end

  def sync_page(path, page)
    success = service.with_api(on_rescue: false) do |api|
      api.upload path, page.image.versions[:large].read
    end

    !!success ? mark_synced(page) : mark_unsynced(page)
  end

  private
    def folder_name(notebook)
      existing = existing_folders
      name     = notebook.name
      date     = notebook.submitted_on || notebook.created_at

      name << " - #{date.strftime('%b %-d, %Y')}" if existing.include?(name.downcase)
      name
    end

    def filename(page)
      "page#" << "%03d" % page.index << ".jpg"
    end

    def existing_folders
      listing = service.with_api(on_rescue: []) { |api| api.ls }

      folders = listing.inject([]) { |memo, l|
        memo << l['path'] if l['is_dir']; memo }

      folders.collect { |f| f.downcase.sub(/^\//i, '') }
    end
end
