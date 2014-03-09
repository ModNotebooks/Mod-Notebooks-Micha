class DropboxSyncer < Syncer

  def sync
    pages = notebook.pages.find_all { |p| needs_sync?(p) }

    unless pages.empty?
      db_folder = folder(notebook)

      db_folder.try do |dbf|
        notebook.update(dropbox_folder_rev: dbf.rev)
        pages.each do |page|
          file = filename(page)
          path = "#{dbf.path}/#{file}"

          sync_page(path, page)
        end
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
    def folder(notebook)
      dropbox_folder = nil
      existing = existing_folders

      # First try an grad the existing folder

      notebook_rev = notebook.dropbox_folder_rev
      dropbox_folder = notebook_rev.try do |rev|
        existing.detect { |folder| folder.rev == rev }
      end

      return dropbox_folder if dropbox_folder

      # If the existing folder does not exsist
      # make a new one
      
      existing_names = existing.collect { |f| f.downcase.sub(/^\//i, '') }
      name     = notebook.name
      date     = notebook.submitted_on || notebook.created_at

      if existing_names.include?(name.downcase)
        name << " - #{date.strftime('%b %-d, %Y')}"
      end

      service.with_api(on_rescue: nil) do |api|
        api.mkdir(name)
      end
    end

    def filename(page)
      "page#" << "%03d" % page.index << ".jpg"
    end

    def existing_folders
      listing = service.with_api(on_rescue: []) { |api| api.ls }

      folders = listing.find_all { |l| l['is_dir'] }
    end
end
