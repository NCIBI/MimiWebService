package org.ncibi.mimiweb.autocomplete;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import org.ncibi.mimiweb.util.PropertiesUtil;

/*
 * This class depends on AutocompleteList. The AutocompleteList class contains
 * one public static data item which is an ArrayList<String> (acList). The reason
 * that this has been abstracted away to that class is to allow multiple threads
 * from a servlet to access it. In this class, when searching the acList, we have
 * thread specific context (for read) that we need to keep around. Thus the acList
 * is abstracted away into a different class.
 */
public class AutocompleteSearcher
{
	private String matchHolder = "";
	private static String mutex = "";
	private static String namesFilePath = null;

	public AutocompleteSearcher()
	{
		if (namesFilePath == null)
		{
			synchronized (mutex)
			{

				try
				{
					namesFilePath = PropertiesUtil.getPath(
							PropertiesUtil.NAMES_FILE_USE_CATALINA_KEY,
							PropertiesUtil.NAMES_FILE_KEY);
				}
				catch (Exception e)
				{
					namesFilePath = "names.txt";
				}
			}
		}
	}

	// Make available for testing interface.
	public static void setNamesFilePath(String path)
	{
		namesFilePath = path;
	}

	private void loadAutocompleteList()
	{
		if (AutocompleteList.isLoaded)
		{
			return;
		}
		BufferedInputStream bis = null;
		BufferedReader input;
		String str = "";

		File file = new File(namesFilePath);
		try
		{
			FileInputStream fis = new FileInputStream(file);

			bis = new BufferedInputStream(fis);
			input = new BufferedReader(new InputStreamReader(bis));

			while ((str = input.readLine()) != null)
			{
				AutocompleteList.acList.add(str);
			}

			fis.close();
			bis.close();
			input.close();
			AutocompleteList.isLoaded = true;
		}
		catch (FileNotFoundException e)
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (IOException e2)
		{
			e2.printStackTrace();
		}

	}

	int findFrom(int index, String matchOn)
	{
		int returnIndex = index - 1;

		while (true)
		{
			if (returnIndex < 0)
			{
				return returnIndex + 1;
			}
			else if (AutocompleteList.acList.get(returnIndex).replaceAll(
					"[-._']", "").matches(matchOn) == false)
			{
				return returnIndex + 1;
			}
			else
			{
				returnIndex--;
			}
		}
	}

	public ArrayList<String> findMatch(String what)
	{
		String matchOn = "^" + what + ".*";

		matchHolder = what;

		ArrayList<String> matches = new ArrayList<String>();
		if (!AutocompleteList.isLoaded)
		{
			synchronized (mutex)
			{
				loadAutocompleteList();
			}
		}

		int index = Collections.binarySearch(AutocompleteList.acList, matchOn,
				new Comparator<String>()
				{
					public int compare(String s1, String s2)
					{
						int rv = s1.compareTo(matchHolder);

						if (rv == 0)
						{
							return rv;
						}
						else if (s1.matches(s2) == true)
						{
							return 0;
						}
						else
						{
							return rv;
						}
					}
				});

		if (index < 0)
		{
			return matches;
		}

		index = findFrom(index, matchOn);
		// Add 10 matches, or less if first match is at end of list
		for (int j = 0; j < 10; j++)
		{
			if ((index + j) < AutocompleteList.acList.size())
			{
				matches.add(AutocompleteList.acList.get(j + index));
			}
			else
			{
				break;
			}
		}

		return matches;
	}
}
