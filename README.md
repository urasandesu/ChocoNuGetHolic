# ChocoNuGetHolic
Haven't you ever experienced as follows?: **"I created an awesome library! However, this depends on a machine wide installed software and a project wide installed library... How should I distribute this package? What should I select package manager?"** For example, ORM that is specialized for a DB, extension library for a VSIX, template that permits to easily write the plugin of a CI system and so on.  
This is one of the solution to resolve such dependency problem by Chocolatey and NuGet.



## QUICK TOUR
Let me say you want to create the package that depends on [Prig(in Chocolatey)](https://chocolatey.org/packages/Prig) and [Moq(in NuGet)](https://www.nuget.org/packages/Moq/). You wanted library that permits to read the test code easier, because [Prig](https://github.com/urasandesu/Prig) has only very primitive feature. Also, it doesn't support the way to create mock.

Complete source code is [here](https://github.com/urasandesu/Moq.Prig).


### Step 1: Install from Chocolatey
Install Chocolatey in accordance with [the top page](https://chocolatey.org/). Then, run command prompt as Administrator, execute the following command: 
```dos
CMD C:\> cinst choconugetholic -y
```


### Step 2: Initialize the package
Go to your package directory, and execute `Initialize-ChocoNuGetHolic` command with your package name. In this case, it is `Moq.Prig`: 
```dos
CMD Moq.Prig> Initialize-ChocoNuGetHolic Moq.Prig
```

If the command succeeded, `Chocolatey` directory will be made in your package directory.


### Step 3: Customize the nuspec for Chocolatey
In the `Chocolatey` directory, you can find the nuspec file for Chocolatey named `<package name>.nuspec`. In this case, it is `Moq.Prig.nuspec`. Open the file 
```xml
<?xml version="1.0" encoding="utf-8"?>
<package>
  <metadata>
    <id>Moq.Prig</id>
    <version>1.0.0</version>
    <authors>urasa</authors>
    <owners>urasa</owners>
    <licenseUrl>http://LICENSE_URL_HERE_OR_DELETE_THIS_LINE</licenseUrl>
    <projectUrl>http://PROJECT_URL_HERE_OR_DELETE_THIS_LINE</projectUrl>
    <iconUrl>http://ICON_URL_HERE_OR_DELETE_THIS_LINE</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>Package description</description>
    <releaseNotes>Summary of changes made in this release of the package.</releaseNotes>
    <copyright>Copyright 2016</copyright>
    <tags>Tag1 Tag2</tags>
    <dependencies>
      <dependency id="nuget.commandline" version="3.3.0" />
    </dependencies>
  </metadata>
  <files>
    <file src="tools\**\*.*" target="tools" />
  </files>
</package>
```

and set necessary as below: 
```xml
<?xml version="1.0"?>
<package >
  <metadata>
    <id>Moq.Prig</id>
    <version>0.0.0</version>
    <title>Moq supplemental library for Prig</title>
    <authors>Akira Sugiura</authors>
    <owners>Akira Sugiura</owners>
    <licenseUrl>https://github.com/urasandesu/Moq.Prig/blob/master/LICENSE.md</licenseUrl>
    <projectUrl>https://github.com/urasandesu/Moq.Prig</projectUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <summary>
      Moq supplemental library for Prig.
    </summary>
    <description>
      This is a library that helps to write test using Moq and Prig.
    </description>
    <copyright>(c) 2016 Akira Sugiura. All rights reserved.</copyright>
    <tags>tdd isolation mock mocks mocking fake fakes faking unittest unittesting</tags>
    <releaseNotes>Version 0.0.0
* Initial release.


About more previous versions, please see https://github.com/urasandesu/Moq.Prig/releases .
    </releaseNotes>
    <dependencies>
      <dependency id="nuget.commandline" version="3.3.0" />
      <dependency id="Prig" version="2.2.0" />
    </dependencies> 
  </metadata>
  <files>
    <file src="tools\**\*.*" target="tools" />
    <file src="..\Moq.Prig\bin\Release(.NET 3.5)\Urasandesu.Moq.Prig.dll" target="lib\net35" />
    <file src="..\Moq.Prig\bin\Release(.NET 4)\Urasandesu.Moq.Prig.dll" target="lib\net40" />
  </files>
</package>
```

**NOTE:** Don't remove the dependency for `nuget.commandline`, because it will be used in the Chocolatey installation script.


### Step 4: Customize the nuspec for NuGet
In the `Chocolatey\tools\NuGet` directory, you can find the nuspec file for NuGet named `<package name>.nuspec.hedge`. In this case, it is `Moq.Prig.nuspec.hedge`. As same as Chocolatey case, open the file 
```xml
<?xml version="1.0" encoding="utf-8"?>
<package>
  <metadata>
    <id>Moq.Prig</id>
    <version>1.0.0</version>
    <authors>urasa</authors>
    <owners>urasa</owners>
    <licenseUrl>http://LICENSE_URL_HERE_OR_DELETE_THIS_LINE</licenseUrl>
    <projectUrl>http://PROJECT_URL_HERE_OR_DELETE_THIS_LINE</projectUrl>
    <iconUrl>http://ICON_URL_HERE_OR_DELETE_THIS_LINE</iconUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <description>Package description</description>
    <releaseNotes>Summary of changes made in this release of the package.</releaseNotes>
    <copyright>Copyright 2016</copyright>
    <tags>Tag1 Tag2</tags>
    <dependencies>
      <dependency id="SampleDependency" version="1.0" />
    </dependencies>
  </metadata>
  <files>
    <file src="..\..\lib\**\*.*" target="lib" />
    <file src="tools\**\*.*" target="tools" />
  </files>
</package>
```

and set necessary as below: 
```xml
<?xml version="1.0"?>
<package >
  <metadata>
    <id>Moq.Prig</id>
    <version>0.0.0</version>
    <title>Moq supplemental library for Prig</title>
    <authors>Akira Sugiura</authors>
    <owners>Akira Sugiura</owners>
    <licenseUrl>https://github.com/urasandesu/Moq.Prig/blob/master/LICENSE.md</licenseUrl>
    <projectUrl>https://github.com/urasandesu/Moq.Prig</projectUrl>
    <requireLicenseAcceptance>false</requireLicenseAcceptance>
    <summary>
      Moq supplemental library for Prig.
    </summary>
    <description>
      This is a library that helps to write test using Moq and Prig.
    </description>
    <copyright>(c) 2016 Akira Sugiura. All rights reserved.</copyright>
    <tags>tdd isolation mock mocks mocking fake fakes faking unittest unittesting</tags>
    <releaseNotes>Version 0.0.0
* Initial release.


About more previous versions, please see https://github.com/urasandesu/Moq.Prig/releases .
    </releaseNotes>
    <dependencies>
      <dependency id="Moq" version="4.1.1308.2120" />
      <dependency id="Prig" version="2.2.0" />
    </dependencies> 
  </metadata>
  <files>
    <file src="..\..\lib\**\*.*" target="lib" />
    <file src="tools\**\*.*" target="tools" />
  </files>
</package>
```

**NOTE:** Don't modify the elements under the `files`, because it will be used in the Chocolatey installation script.


### Final Step: Publish to Chocolatey
In the rest, you just publish the package to Chocolatey as usual. In this case, execute `cpack Moq.Prig.nuspec` and upload `Moq.Prig.0.0.0.nupkg` to [Chocolatey](https://chocolatey.org/packages/upload).



