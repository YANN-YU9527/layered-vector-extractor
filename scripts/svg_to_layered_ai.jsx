#target illustrator

(function () {
    function trim(value) {
        return String(value).replace(/^\s+|\s+$/g, '');
    }

    function cleanLayerName(groupName) {
        var name = trim(groupName || '');
        name = name.replace(/^layer[-_]?/i, '');
        name = name.replace(/[-_]+/g, ' ');
        return name || '未命名图层';
    }

    function uniqueAIFile(svgFile) {
        var stem = svgFile.name.replace(/\.svg$/i, '');
        var candidate = new File(svgFile.parent.fsName + '/' + stem + '.ai');
        var counter = 2;
        while (candidate.exists) {
            candidate = new File(svgFile.parent.fsName + '/' + stem + '-' + counter + '.ai');
            counter += 1;
        }
        return candidate;
    }

    var svgFile = File.openDialog('Choose a tagged layered SVG', 'SVG:*.svg');
    if (!svgFile) { return; }

    var previousInteraction = app.userInteractionLevel;
    var documentRef = null;
    var outputFile = null;
    var failure = null;

    try {
        app.userInteractionLevel = UserInteractionLevel.DONTDISPLAYALERTS;
        documentRef = app.open(svgFile);

        if (documentRef.layers.length < 1) {
            throw new Error('The SVG did not open with an Illustrator layer.');
        }

        var importLayer = documentRef.layers[0];
        var candidates = [];
        var i;

        for (i = 0; i < importLayer.groupItems.length; i += 1) {
            var item = importLayer.groupItems[i];
            if (item.parent === importLayer && /^layer[-_]/i.test(item.name || '')) {
                candidates.push(item);
            }
        }

        if (candidates.length === 0) {
            throw new Error('No top-level SVG groups named layer-* were found. Run the SVG audit first.');
        }

        // Illustrator adds new layers at the top. Moving bottom-to-top keeps the visual order.
        for (i = candidates.length - 1; i >= 0; i -= 1) {
            var group = candidates[i];
            var newLayer = documentRef.layers.add();
            newLayer.name = cleanLayerName(group.name);
            group.move(newLayer, ElementPlacement.PLACEATBEGINNING);
        }

        if (importLayer.pageItems.length === 0 && documentRef.layers.length > 1) {
            importLayer.remove();
        } else {
            importLayer.name = '未分类对象';
        }

        outputFile = uniqueAIFile(svgFile);
        var options = new IllustratorSaveOptions();
        options.pdfCompatible = true;
        options.compressed = true;
        options.embedICCProfile = true;
        options.embedLinkedFiles = false;

        documentRef.saveAs(outputFile, options);
        documentRef.close(SaveOptions.DONOTSAVECHANGES);
        documentRef = null;
    }
    catch (error) {
        failure = error;
        if (documentRef) {
            try { documentRef.close(SaveOptions.DONOTSAVECHANGES); } catch (ignored) {}
        }
    }
    finally {
        app.userInteractionLevel = previousInteraction;
    }

    if (failure) {
        alert('Layered AI conversion failed:\n' + failure.message);
    } else {
        alert('Created layered Illustrator file:\n' + outputFile.fsName + '\n\nReopen it and inspect the Layers panel before delivery.');
    }
}());
